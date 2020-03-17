select * from usuarios;

select estado, descTwits from twits where usuarios_nickName="mfcortes" order by idtwits desc;

select estado, descTwits from twits where  descTwits like "%HuelgaEntel%" and estado="pub";

select count(*) q, usuarios_nickName from twits group by usuarios_nickName order by q desc;
select * from twits where errorpublicar is null;
select * from twits where errorpublicar!=1;

select * from credencialestwiter;
select * from twits where usuarios_nickName="encolpius" order by idtwits desc;
select count(*) from twits where  descTwits like "%HuelgaEntel%" and estado!="pub" and errorpublicar is null;

select * from hashtag;
select * from twits_hashtag;

select desc_hashtag from hashtag where idproceso=3;

select * from hashtag ;
delete from hashtag;
select * from twits where idtwits='606144471282118657';

select count(*) from twits;

select idtwits, descTwits from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and   t.estado="publicar" and errorpublicar is null;

select descTwits,retwitscount+favoritecount from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE);


ls -ltrgo select estado from twits;

update twits set twits.estado="ing" 
where estado!="ing";

select descTwits,retwitscount+favoritecount from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and t.estado!="publicar" and fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE);


