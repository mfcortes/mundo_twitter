insert into credencialestwiter (idproceso,consumerkey,consumersecret,accestoken,accestokensecret) 
values (1,"75H8kLNN1nVB10npFCRU9ARm5","9wHl7V9SDmO7UoQa6GLyFEh1ApsY3gNgvIfdltEYOucvmNDF3N","30951060-gKq54u2hxfu14j1kT4BAgMiXpIVTAYFk8cd4vedQb","tZYd61T45yRtuAEgk2RKfLQLaypmGwwv22AfSJcDS45zl");
insert into credencialestwiter (idproceso,consumerkey,consumersecret,accestoken,accestokensecret) 
values (2,"75H8kLNN1nVB10npFCRU9ARm5","9wHl7V9SDmO7UoQa6GLyFEh1ApsY3gNgvIfdltEYOucvmNDF3N","30951060-gKq54u2hxfu14j1kT4BAgMiXpIVTAYFk8cd4vedQb","tZYd61T45yRtuAEgk2RKfLQLaypmGwwv22AfSJcDS45zl");



select * from credencialestwiter;
select idproceso,consumerkey,consumersecret,accestoken,accestokensecret from credencialestwiter where idproceso=1;
select idproceso,consumerkey,consumersecret,accestoken,accestokensecret from credencialestwiter where idproceso=1;


select * from twits where idtwits="556899110956326917";
select *  from twits where errorpublicar=1;
insert into usuarios (nickName,grupo_idgrupo,idproceso) values ("cristianmorenop",3,1);
select * from usuarios;
select * from grupo;
select * from credencialestwiter;
select DISTINCT idproceso from usuarios;
delete  from usuarios where nickName in ('carlostph','cocorrales','evil_emilio','feok','lacuarta');

delete  from twits;