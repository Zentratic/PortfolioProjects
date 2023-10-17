create table classification
  (Abbreviation varchar(2) constraint pk_classification primary key constraint chk_abb check(abbreviation in ('FR','SO','JR','SR','GR')),
  classification varchar(10)
  constraint chk_classification check ( classification in ('Freshman', 'Sophomore', 'Junior', 'Senior', 'Graduate'))
    );

create table equipment
   (item_id varchar(4) constraint pk_equipment primary key,
   description varchar(30),
   max_onhand int,
   checked_out int,
   constraint chk_qty check (max_onhand= (max_onhand - checked_out)) );

   create table college 
   (college varchar(30) constraint pk_college primary key);

   create table major
    (college varchar(30),
    major varchar(28),
    constraint pk_major primary key (college, major),
    constraint fk_college foreign key (college) references college (college) );

	create table captain
    (captain_id int constraint pk_captain primary key,
    first_name varchar(15),
    last_name varchar(15),
    gender varchar(1) constraint chk_gender check (gender in ('M', 'F')),
    classification varchar(2) constraint chk_class check(classification in ('FR','SO','JR','SR','GR')),
    college varchar(30),
    major varchar(28),
    hrs_attempted int,
    hrs_completed int,
    gpa int ,
    constraint chk_hrs check ((classification = 'FR' AND hrs_completed < 31) OR (classification='SO' AND hrs_completed BETWEEN 31 AND 61) OR (classification='JR' AND hrs_completed BETWEEN 61 AND 91) OR (classification='SR' AND hrs_completed BETWEEN 91 AND 120) OR (classification='GR' AND hrs_completed > 120)),
    constraint fk_college_major foreign key (college, major) references major (college, major),
    constraint fk_classification foreign key (classification) references classification (Abbreviation));

	create table highlineitem (trs_no int constraint pk_highlineitem primary key,
     item_id varchar(4),
     quantity int,
     description varchar(30),
     dateout date,
     datein date,
     captain_id int,
     constraint chk_date check (dateout < datein) ,
     constraint fk_equipment foreign key (item_id) references equipment (item_id) ON DELETE CASCADE,
    constraint fk_captain foreign key (captain_id) references captain (captain_id) ON DELETE CASCADE) ;

