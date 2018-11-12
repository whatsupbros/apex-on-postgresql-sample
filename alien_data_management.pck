create or replace package alien_data_management is

type t_employee is record (
  employee_id integer,
  department_id integer,
  name varchar2(50),
  email varchar2(255),
  cost_center integer,
  date_hired date,
  job varchar2(255)
);

type tbl_employees is table of t_employee;

procedure add_department(
  p_name varchar2,
  p_location varchar2,
  p_country varchar2
);

procedure update_department(
  p_department_id integer,
  p_name varchar2,
  p_location varchar2,
  p_country varchar2
);

procedure delete_department(
  p_department_id integer
);

function get_employees return tbl_employees pipelined;

procedure add_employee(
  p_department_id integer,
  p_name varchar2,
  p_email varchar2,
  p_cost_center integer,
  p_date_hired date,
  p_job varchar2
);

procedure update_employee(
  p_employee_id integer,
  p_department_id integer,
  p_name varchar2,
  p_email varchar2,
  p_cost_center integer,
  p_date_hired date,
  p_job varchar2
);

procedure delete_employee(
  p_employee_id integer
);

end alien_data_management;
/
create or replace package body alien_data_management is

procedure add_department(
  p_name varchar2,
  p_location varchar2,
  p_country varchar2
) is
  -- parameters collection variable
  l_parameters apex_exec.t_parameters;
begin
  -- prepare the parameters for the Web Service operation
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'NAME',     p_value => p_name);
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'LOCATION', p_value => p_location);
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'COUNTRY',  p_value => p_country);

  -- invoke POST operation, defined in the Web Service definition
  begin
    apex_exec.execute_web_source(
        p_module_static_id => 'ALIEN_DEPARTMENTS',
        p_operation        => 'POST',
        p_parameters       => l_parameters
    );
  -- we are handling VALUE_ERROR exceptions because of
  -- weird ORA-06502: PL/SQL: numeric or value error
  -- after a successful REST API call
  -- more here: https://community.oracle.com/message/14988842
  exception when VALUE_ERROR then
    null;
  end;
end add_department;

procedure update_department(
  p_department_id integer,
  p_name varchar2,
  p_location varchar2,
  p_country varchar2
) is
  -- parameters collection variable
  l_parameters apex_exec.t_parameters;
begin
  -- prepare the parameters for the Web Service operation
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'department_id', p_value => 'eq.'||to_char(p_department_id));
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'NAME', p_value => p_name);
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'LOCATION', p_value => p_location);
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'COUNTRY', p_value => p_country);

  -- invoke POST operation, defined in the Web Service definition
  begin
    apex_exec.execute_web_source(
        p_module_static_id => 'ALIEN_DEPARTMENTS',
        p_operation        => 'PATCH',
        p_parameters       => l_parameters
    );
  -- we are handling VALUE_ERROR exceptions because of
  -- weird ORA-06502: PL/SQL: numeric or value error
  -- after a successful REST API call
  -- more here: https://community.oracle.com/message/14988842
  exception when VALUE_ERROR then
    null;
  end;
end update_department;

procedure delete_department(
  p_department_id integer
) is
  -- parameters collection variable
  l_parameters apex_exec.t_parameters;
begin
  -- prepare the parameters for the Web Service operation
  apex_exec.add_parameter(p_parameters => l_parameters, p_name => 'department_id', p_value => 'eq.'||to_char(p_department_id));

  -- invoke POST operation, defined in the Web Service definition
  begin
    apex_exec.execute_web_source(
        p_module_static_id => 'ALIEN_DEPARTMENTS',
        p_operation        => 'DELETE',
        p_parameters       => l_parameters
    );
  -- we are handling VALUE_ERROR exceptions because of
  -- weird ORA-06502: PL/SQL: numeric or value error
  -- after a successful REST API call
  -- more here: https://community.oracle.com/message/14988842
  exception when VALUE_ERROR then
    null;
  end;
end delete_department;

function get_employees return tbl_employees pipelined
is
  E_NO_MORE_ROWS_NEEDED exception;
  pragma exception_init(E_NO_MORE_ROWS_NEEDED, -6548);
  l_response clob;
begin
  -- REST request to get JSON data from alien database
  l_response := apex_web_service.make_rest_request(
    p_url => 'http://192.168.88.31:8000/employees',
    p_http_method => 'GET'
  );

  -- converting JSON data to relational
  -- and returning it as result set
  for x in (
    select
      employee_id,
      department_id,
      name,
      email,
      cost_center,
      date_hired,
      job
   from json_table(
      l_response,
      '$[*]' columns (
        employee_id integer,
        department_id integer,
        name varchar2(50),
        email varchar2(255),
        cost_center integer,
        date_hired date,
        job varchar2(255)
      )
    )
  ) loop
    pipe row(
      t_employee(
        x.employee_id,
        x.department_id,
        x.name,
        x.email,
        x.cost_center,
        x.date_hired,
        x.job
      )
    );
  end loop;

  return;
-- APEX reacts inadequately on `NO MORE ROWS NEEDED` exception
-- and generates `404 Not Found` error if not suppress it
-- more here: https://community.oracle.com/thread/4076787
exception when E_NO_MORE_ROWS_NEEDED then
  null;
end get_employees;

procedure add_employee(
  p_department_id integer,
  p_name varchar2,
  p_email varchar2,
  p_cost_center integer,
  p_date_hired date,
  p_job varchar2
) is
  l_json_body json_object_t := json_object_t();
  l_response clob;
begin
  -- setting HTTP headers before the REST API call
  apex_web_service.g_request_headers(1).name := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/json; charset=utf-8';

  -- preparation of the body
  -- put method of the json_object_t type accepts various data types
  l_json_body.put(key => 'department_id', val => p_department_id);
  l_json_body.put(key => 'name', val => p_name);
  l_json_body.put(key => 'email', val => p_email);
  l_json_body.put(key => 'cost_center', val => p_cost_center);
  l_json_body.put(key => 'date_hired', val => p_date_hired);
  l_json_body.put(key => 'job', val => p_job);

  -- REST request to alien database to perform insert operation
  l_response := apex_web_service.make_rest_request(
    p_url => 'http://192.168.88.31:8000/employees',
    p_http_method => 'POST',
    p_body => l_json_body.to_clob()
  );

end add_employee;

procedure update_employee(
  p_employee_id integer,
  p_department_id integer,
  p_name varchar2,
  p_email varchar2,
  p_cost_center integer,
  p_date_hired date,
  p_job varchar2
) is
  l_json_body json_object_t := json_object_t();
  l_url varchar2(200);
  l_response clob;
begin
  -- setting HTTP headers before the REST API call
  apex_web_service.g_request_headers(1).name := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/json; charset=utf-8';

  -- preparation of the body
  -- put method of the json_object_t type accepts various data types
  l_json_body.put(key => 'department_id', val => p_department_id);
  l_json_body.put(key => 'name', val => p_name);
  l_json_body.put(key => 'email', val => p_email);
  l_json_body.put(key => 'cost_center', val => p_cost_center);
  l_json_body.put(key => 'date_hired', val => p_date_hired);
  l_json_body.put(key => 'job', val => p_job);

  -- prepare the URL
  -- have not found a better way to specify query string parameters
  l_url := 'http://192.168.88.31:8000/employees?employee_id=eq.'||to_char(p_employee_id);

  -- REST request to alien database to perform update operation
  l_response := apex_web_service.make_rest_request(
    p_url => l_url,
    p_http_method => 'PATCH',
    p_body => l_json_body.to_clob()
  );

end update_employee;

procedure delete_employee(
  p_employee_id integer
) is
  l_url varchar2(200);
  l_response clob;
begin
  -- setting HTTP headers before the REST API call
  apex_web_service.g_request_headers(1).name := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/json; charset=utf-8';

  -- prepare the URL
  -- have not found a better way to specify query string parameters
  l_url := 'http://192.168.88.31:8000/employees?employee_id=eq.'||to_char(p_employee_id);

  -- REST request to alien database to perform update operation
  l_response := apex_web_service.make_rest_request(
    p_url => l_url,
    p_http_method => 'DELETE'
  );

end delete_employee;

end alien_data_management;
/
