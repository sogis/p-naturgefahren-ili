-- hotfix against:
-- Error: Object 16631feb-cf51-4c1d-9720-adc9c423c6b7 at (line 13,col 97)
-- Error:   ERROR: column "t_ili_tid" is of type uuid but expression is of type character varying
--   Hinweis: You will need to rewrite or cast the expression.
--   Position: 211
-- Error:       org.postgresql.core.v3.QueryExecutorImpl.receiveErrorResponse(QueryExecutorImpl.java:2553)
-- Error:       org.postgresql.core.v3.QueryExecutorImpl.processResults(QueryExecutorImpl.java:2285)
-- Error:       org.postgresql.core.v3.QueryExecutorImpl.execute(QueryExecutorImpl.java:323)
-- Error:       org.postgresql.jdbc.PgStatement.executeInternal(PgStatement.java:473)
-- Error:       org.postgresql.jdbc.PgStatement.execute(PgStatement.java:393)
-- Error:       org.postgresql.jdbc.PgPreparedStatement.executeWithFlags(PgPreparedStatement.java:164)
-- Error:       org.postgresql.jdbc.PgPreparedStatement.executeUpdate(PgPreparedStatement.java:130)
-- Error:       ch.ehi.ili2db.base.StatementExecutionHelper.write(StatementExecutionHelper.java:36)
-- Error:       ch.ehi.ili2db.fromxtf.TransferFromXtf.writeObject(TransferFromXtf.java:1605)
-- Error:       ch.ehi.ili2db.fromxtf.TransferFromXtf.doObject(TransferFromXtf.java:1194)
-- Error:       ch.ehi.ili2db.fromxtf.TransferFromXtf.doit(TransferFromXtf.java:638)
-- Error:       ch.ehi.ili2db.base.Ili2db.transferFromXtf(Ili2db.java:2459)
-- Error:       ch.ehi.ili2db.base.Ili2db.runUpdate(Ili2db.java:745)
-- Error:       ch.ehi.ili2db.base.Ili2db.run(Ili2db.java:215)
-- Error:       ch.ehi.ili2db.AbstractMain.domain(AbstractMain.java:644)
-- Error:       ch.ehi.ili2pg.PgMain.main(PgMain.java:72)


ALTER TABLE public.prozessquelle ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.auftrag ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.teilauftragrutschsturz ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.teilauftragpermanenteprozesse ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.prozessquellesteinblockschlagpolygon ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.prozessquelle ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.befundsteinblockschlag ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.befundbergfelssturz  ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;
ALTER TABLE public.befundhangmure  ALTER COLUMN t_ili_tid TYPE varchar USING t_ili_tid::varchar;