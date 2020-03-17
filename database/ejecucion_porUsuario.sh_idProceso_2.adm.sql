#delete from grupo;select * from grupo;
select  * from canal;
insert into canal (nombrecanal) values ("deportes");
insert into canal (nombrecanal) values ("Crónica");
insert into canal (nombrecanal) values ("Mundo");
insert into canal (nombrecanal) values ("Espetaculo");
insert into canal (nombrecanal) values ("Mascotas");
insert into canal (nombrecanal) values ("Lacuarta");


update grupo set descGrupo="Periodista" where idgrupo=3;
insert into grupo (descGrupo) values ("Lacuarta");
update grupo set descGrupo="La Cuarta" where idgrupo=4;
insert into grupo (descGrupo) values ("Otros Medios Escritos");
select * from grupo;

#delete from usuarios;
#delete from twits;

insert into usuarios (nickName,grupo_idgrupo,idproceso,canal_id) values ("celiapunkpop",3,1,3);
insert into usuarios (nickName,grupo_idgrupo,idproceso,canal_id) values ("cfajardoc",3,1,3);
insert into usuarios (nickName,grupo_idgrupo,idproceso,canal_id) values ("cmendezdlf69",3,1,6);
insert into usuarios (nickName,grupo_idgrupo,idproceso,canal_id) values ("sebastianfoncea",3,1,4);
insert into usuarios (nickName,grupo_idgrupo,idproceso,canal_id) values ("mfcortes",3,1,4);
insert into usuarios (nickName,grupo_idgrupo,idproceso,canal_id) values ("lacuarta",4,2,4);
select * from usuarios;

update usuarios set grupo_idgrupo=4 where nickName="lacuarta";
select descTwits from twits;

select count(*) from twits;
select * from twits order by idtwits desc;
select nickName from usuarios where idproceso=1;
select nickName from usuarios where idproceso=2;

select descTwits from twits where usuarios_nickName !='lacuarta' and fechatwits > DATE_SUB(now(), INTERVAL 60 MINUTE) and descTwits like '%facundo%';

select descTwits,retwitscount+favoritecount from twits where fechatwits > 
DATE_SUB(now(), INTERVAL 10 MINUTE);

select * from twits where descTwits like "%facundo%";

select nickName from usuarios where idproceso=2;
select nickName from usuarios where idproceso=1;

select count(*),usuarios_nickName,date_format(fechatwits,'%Y%m%d') AS agnomes 
       					from twits 
       					group by usuarios_nickName,agnomes order by agnomes;
select count(*),usuarios_nickName,date_format(fechatwits,'%Y%m%d') AS agnomes 
       					from twits where usuarios_nickName = "lacuarta" 
       					group by usuarios_nickName,agnomes  order by agnomes;
select count(*) as cadescntidad, usuarios_nickName from twits group by usuarios_nickName order by cantidad desc;
