create table users  (util_id serial PRIMARY KEY,
					 user_name varchar(20) not null,
					 user_password varchar (20) not null
					 );
					 
create table cardio_history (hist_id serial PRIMARY KEY,
							 hist_date date not null,
							 hist_result varchar(20) not null
							 );
					 
create table checklist (list_id serial PRIMARY KEY,
						list_name varchar(20) not null,
						list_main boolean not null,
					    user_id_FK int not null
					    );
						
create table check_item (item_id serial PRIMARY KEY,
						item_name varchar(20) not null,
						item_check boolean not null,
					    list_id_FK int not null
					    );
						




					 