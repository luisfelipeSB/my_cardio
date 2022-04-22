create table users  (user_id serial PRIMARY KEY,
					 user_name varchar(20) not null,
					 user_password varchar (20) not null
					 );
					 
create table cardio_history (hist_id serial PRIMARY KEY,
							 hist_date date not null,
							 hist_result varchar(20) not null
							 );
						
create table checklist (item_id serial PRIMARY KEY,
						item_name varchar(20) not null,
						item_check boolean not null,
					    user_id_FK int not null
					    );
						
		
			
alter table checklist add constraint users_fk_checklist
            foreign key (user_id_FK) references users(user_id) 
			ON DELETE NO ACTION ON UPDATE NO ACTION; 






					 