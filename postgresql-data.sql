begin;

-- tables
create table departments (
    department_id                  serial constraint departments$pk primary key,
    name                           varchar(255) not null,
    location                       varchar(4000),
    country                        varchar(4000)
);

create table employees (
    employee_id                    serial constraint employees$pk primary key,
    department_id                  integer
                                   constraint employees_department_id_fk
                                   references departments on delete cascade,
    name                           varchar(50) not null,
    email                          varchar(255),
    cost_center                    integer,
    date_hired                     date,
    job                            varchar(255)
);

-- indexes
create index employees_i1 on employees (department_id);

-- data
insert into departments (department_id, name, location, country)
values
    (1, 'Product Support',             'Tanquecitos', 'United States'),
    (2, 'Electronic Data Interchange', 'Sugarloaf',   'United States'),
    (3, 'Legal',                       'Dale City',   'United States'),
    (4, 'Transportation',              'Grosvenor',   'United States'),
    (5, 'Finance',                     'Riverside',   'United States');

insert into employees (department_id, name, email, cost_center, date_hired, job)
values
    (1, 'Gricelda Luebbers',   'gricelda.luebbers@aaab.com',  82,  current_date - 4,  'Marketing Associate'),
    (1, 'Dean Bollich',        'dean.bollich@aaac.com',       83,  current_date - 88, 'Usability Engineer'),
    (1, 'Milo Manoni',         'milo.manoni@aaad.com',        64,  current_date - 28, 'Analyst'),
    (1, 'Laurice Karl',        'laurice.karl@aaae.com',       56,  current_date - 58, 'Evengilist'),
    (1, 'August Rupel',        'august.rupel@aaaf.com',       1,   current_date - 37, 'Analyst'),
    (1, 'Salome Guisti',       'salome.guisti@aaag.com',      6,   current_date - 2,  'Marketing Manager'),
    (1, 'Lovie Ritacco',       'lovie.ritacco@aaah.com',      91,  current_date - 4,  'Help Desk Specialist'),
    (1, 'Chaya Greczkowski',   'chaya.greczkowski@aaai.com',  55,  current_date - 66, 'Support Specialist'),
    (1, 'Twila Coolbeth',      'twila.coolbeth@aaaj.com',     22,  current_date - 88, 'Support Specialist'),
    (1, 'Carlotta Achenbach',  'carlotta.achenbach@aaak.com', 99,  current_date - 19, 'Marketing Manager'),
    (1, 'Jeraldine Audet',     'jeraldine.audet@aaal.com',    41,  current_date - 84, 'Quality Control Specialist'),
    (1, 'August Arouri',       'august.arouri@aaam.com',      54,  current_date - 95, 'Customer Advocate'),
    (1, 'Ward Stepney',        'ward.stepney@aaan.com',       41,  current_date - 99, 'Cloud Architect'),
    (1, 'Ayana Barkhurst',     'ayana.barkhurst@aaao.com',    42,  current_date - 76, 'Sustaining Engineering'),
    (1, 'Luana Berends',       'luana.berends@aaap.com',      24,  current_date - 32, 'Vice President'),
    (1, 'Lecia Alvino',        'lecia.alvino@aaaq.com',       29,  current_date - 43, 'Engineer'),
    (1, 'Joleen Himmelmann',   'joleen.himmelmann@aaar.com',  20,  current_date - 14, 'Business Applications'),
    (1, 'Monty Kinnamon',      'monty.kinnamon@aaas.com',     85,  current_date - 24, 'Usability Engineer'),
    (1, 'Dania Grizzard',      'dania.grizzard@aaat.com',     53,  current_date - 11, 'Project Manager'),
    (1, 'Inez Yamnitz',        'inez.yamnitz@aaau.com',       75,  current_date - 53, 'HR Representitive'),
    (1, 'Fidel Creps',         'fidel.creps@aaav.com',        41,  current_date - 22, 'President'),
    (1, 'Luis Pothoven',       'luis.pothoven@aaaw.com',      12,  current_date - 44, 'Sales Consultant'),
    (1, 'Bernardo Phoenix',    'bernardo.phoenix@aaax.com',   11,  current_date - 68, 'Software Engineer'),
    (1, 'Carolyne Centore',    'carolyne.centore@aaay.com',   61,  current_date - 88, 'Business Operations'),
    (1, 'Cornell Pratico',     'cornell.pratico@aaaz.com',    51,  current_date - 92, 'System Operations'),
    (1, 'Sam Rueb',            'sam.rueb@aaa0.com',           83,  current_date - 49, 'Sustaining Engineering'),
    (1, 'Shakita Sablock',     'shakita.sablock@aaa1.com',    96,  current_date - 39, 'Data Architect'),
    (1, 'Sandy Heffren',       'sandy.heffren@aaa2.com',      58,  current_date - 58, 'Systems Administrator'),
    (1, 'Tressa Coppens',      'tressa.coppens@aaa3.com',     1,   current_date - 48, 'Business Operations'),
    (1, 'Shira Arocho',        'shira.arocho@aaa4.com',       8,   current_date - 7,  'Sales Representative'),
    (1, 'Carter Sacarello',    'carter.sacarello@aaa5.com',   89,  current_date - 62, 'Security Specialist'),
    (1, 'Linda Merida',        'linda.merida@aaa6.com',       55,  current_date - 55, 'Support Specialist'),
    (1, 'Winfred Sohn',        'winfred.sohn@aaa7.com',       92,  current_date - 73, 'User Experience Manager'),
    (1, 'Nestor Caparros',     'nestor.caparros@aaa8.com',    39,  current_date - 59, 'Systems Administrator'),
    (1, 'Brooks Craker',       'brooks.craker@aaa9.com',      37,  current_date - 36, 'Engineer'),
    (1, 'Ruthann Nixa',        'ruthann.nixa@aaba.com',       88,  current_date - 20, 'Analyst'),
    (1, 'Kenny Campobasso',    'kenny.campobasso@aabb.com',   15,  current_date - 63, 'Customer Advocate'),
    (1, 'Hildred Donnel',      'hildred.donnel@aabc.com',     73,  current_date - 30, 'Business Operations'),
    (1, 'Luther Ardinger',     'luther.ardinger@aabd.com',    71,  current_date - 6,  'Web Developer'),
    (1, 'Rhoda Hasfjord',      'rhoda.hasfjord@aabe.com',     100, current_date - 28, 'Security Specialist'),
    (1, 'Cori Ablin',          'cori.ablin@aabf.com',         26,  current_date - 30, 'Cloud Architect'),
    (1, 'Reinaldo Feltner',    'reinaldo.feltner@aabg.com',   42,  current_date - 82, 'Webmaster'),
    (1, 'Coralee Acerno',      'coralee.acerno@aabh.com',     93,  current_date - 31, 'Director'),
    (1, 'Katherine Tagg',      'katherine.tagg@aabi.com',     74,  current_date - 84, 'Marketing Manager'),
    (1, 'Lenore Sullivan',     'lenore.sullivan@aabj.com',    45,  current_date - 42, 'Network Architect'),
    (1, 'erda Sheer',          'erda.sheer@aabk.com',         57,  current_date - 18, 'Accounting Analyst'),
    (1, 'Pete Chevis',         'pete.chevis@aabl.com',        19,  current_date - 68, 'Webmaster'),
    (1, 'Joseph Wilke',        'joseph.wilke@aabm.com',       15,  current_date - 63, 'Quality Assurance Analyst'),
    (1, 'Nella Rupnick',       'nella.rupnick@aabn.com',      26,  current_date - 70, 'Security Specialist'),
    (1, 'Azalee Goodwater',    'azalee.goodwater@aabo.com',   14,  current_date - 39, 'Business Development Manager');

commit;
