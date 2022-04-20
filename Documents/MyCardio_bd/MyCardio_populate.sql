insert into users (user_name, user_password) values ('Hugo', '123');

insert into checklist (list_name, list_main, user_id_FK) values ('Main', true, 1);
insert into checklist (list_name, list_main, user_id_FK) values ('Random', false, 1);

insert into check_item (item_name, item_check, list_id_FK) values ('Lavar a loiça', true, 1);
insert into check_item (item_name, item_check, list_id_FK) values ('Fazer o exame', true, 1);
insert into check_item (item_name, item_check, list_id_FK) values ('Cozinhar', false, 1);
insert into check_item (item_name, item_check, list_id_FK) values ('Ir ás compras', false, 1);
insert into check_item (item_name, item_check, list_id_FK) values ('Limpar a casa', true, 1);
insert into check_item (item_name, item_check, list_id_FK) values ('Investir', false, 1);

insert into check_item (item_name, item_check, list_id_FK) values ('Comer', true, 2);
insert into check_item (item_name, item_check, list_id_FK) values ('Dormir', true, 2);
insert into check_item (item_name, item_check, list_id_FK) values ('Sair à noite', false, 2);
insert into check_item (item_name, item_check, list_id_FK) values ('Beber um shot', false, 2);
insert into check_item (item_name, item_check, list_id_FK) values ('Conhecer alguém', false, 2);
insert into check_item (item_name, item_check, list_id_FK) values ('Fazer a cama', false, 2);