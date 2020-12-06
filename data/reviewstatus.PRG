SELECT r.pk,  u.name as reviewer,;
a.act, s.dopen  FROM staffreview r JOIN ;
act a ON r.actpk = a.pk join;
schedule s ON r.actpk = s.actpk JOIN ;
staff u on r.staffpk = u.pk WHERE EMPTY(r.dcreate) ORDER BY s.dopen
