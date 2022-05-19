create table amd_acto_medico (codigo int not null,

                          doente int not null,

                          tipo_acto_medico int not null,

                          primary key (codigo));


create table amd_tipo_acto_medico (codigo int not null,

                          tipo_acto_medico varchar(20) not null,

                          descricao varchar(120) not null,

                          primary key (codigo));


create table dnt_doente (codigo int not null,

                          sexo char(1) not null check(sexo='M' or sexo='F'),

                          data_nascimento date,

			  falecido char(1) check(falecido='S' or falecido='N'),

                          primary key (codigo));


create table rmt_device (id int not null,

                          description varchar(60) not null unique,

			  device_type int not null,

                          primary key (id));


create table rmt_device_type (id int not null,

                          description varchar(20) not null unique, 

                          primary key (id));


create table rmt_device_type_measure_type (id int not null unique,

                          device_type int not null,

			  measure_type int not null,

                          primary key (id));


create table rmt_end_measure (measure int not null,

                          end_instant timestamp not null, 

                          primary key (measure));


create table rmt_measure (id int not null,

                          medical_act int not null,

			  device_type_measure_type int not null,

			  instant timestamp not null,

			  value decimal(30,15) not null,

                          primary key (id));


create table rmt_measure_type (id int not null,

                          description varchar(60) not null unique,

			  unit varchar(20) not null,

                          primary key (id));


create table rmt_measure_type_pt (measure_type int not null,

                          description varchar(60) not null unique,

                          primary key (measure_type));


create table rmt_medical_act_device (id int not null,

                          medical_act int not null,

			  device int not null,

			  start_date date not null,

			  end_date date,

                          primary key (id));
						  
create table checklist (item_id serial PRIMARY KEY,
						item_name varchar(100) not null,
						item_check boolean not null,
						item_category varchar(100) not null,
					    user_id_FK int not null
					    );


-- *********************************** CHAVES ESTRANGEIRAS *****************************************

alter table checklist add constraint users_fk_checklist
            foreign key (user_id_FK) references dnt_doente(codigo) 
			ON DELETE NO ACTION ON UPDATE NO ACTION; 

alter table amd_acto_medico add constraint amd_acto_medico_fk_dnt_doente

            foreign key (doente) references dnt_doente(codigo) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;


alter table amd_acto_medico add constraint amd_acto_medico_fk_amd_tipo_acto_medico

            foreign key (tipo_acto_medico) references amd_tipo_acto_medico(codigo) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;


alter table rmt_device add constraint rmt_device_fk_rmt_device_type

            foreign key (device_type) references rmt_device_type(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;


alter table rmt_device_type_measure_type add constraint rmt_device_type_measure_type_fk_rmt_device_type

            foreign key (device_type) references rmt_device_type(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;


alter table rmt_device_type_measure_type add constraint rmt_device_type_measure_type_fk_rmt_measure_type

            foreign key (measure_type) references rmt_measure_type(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;



alter table rmt_end_measure add constraint rmt_end_measure_fk_rmt_measure

            foreign key (measure) references rmt_measure(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;



alter table rmt_measure add constraint rmt_measure_fk_rmt_device_type_measure_type

            foreign key (device_type_measure_type) references rmt_device_type_measure_type(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;



alter table rmt_measure add constraint rmt_measure_fk_amd_acto_medico

            foreign key (medical_act) references amd_acto_medico(codigo) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;



alter table rmt_measure_type_pt add constraint rmt_measure_type_pt_fk_rmt_measure_type

            foreign key (measure_type) references rmt_measure_type(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;



alter table rmt_medical_act_device add constraint rmt_medical_act_device_fk_amd_acto_medico

            foreign key (medical_act) references amd_acto_medico(codigo) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;



alter table rmt_medical_act_device add constraint rmt_medical_act_device_fk_rmt_device

            foreign key (device) references rmt_device(id) 

			ON DELETE NO ACTION ON UPDATE NO ACTION;





