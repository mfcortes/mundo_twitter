select * from usuarios;
select nickName from usuarios where idproceso=1;

update usuarios set idproceso=1 where nickname in ("carlostph","cocorrales","epsilva","mfcortes","pelaonacho");
update usuarios set idproceso=2 where nickname in ("evil_emilio","feok","flaitechileno","mfcortes","lacuarta");