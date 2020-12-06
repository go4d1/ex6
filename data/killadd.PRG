USE staff EXCLUSIVE
ALTER table staff ADD COLUMN lactive l
USE 
*!*	USE jcschedule EXCLUSIVE
*!*	ALTER table jcschedule ADD COLUMN bppk i
*!*	CLOSE DATABASES all


*!*	SELECT staff
*!*	USE staff EXCLUSIVE
*!*	MODIFY STRUCTURE
*!*	REPLACE lactive WITH .t. all
