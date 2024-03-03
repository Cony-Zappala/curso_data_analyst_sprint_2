#ejercicio 1:
SELECT company.company_name, company.id, company.country
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
WHERE company.country = "Germany" ;
#Podemos ver todas las transacciones realizadas por las 8 empresas alemanas. Son 118 operaciones.
#He calculado anteriormente con el agregado de AND declined = 0 para que contabilice únicamente las transacciones efectivas
#y en ese caso el total ha sido de 111 operaciones. 

#ejercicio 2:
SELECT company.company_name, company.id, transaction.amount
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
WHERE transaction.amount > (
	SELECT AVG(transaction.amount)
    FROM transactions.transaction
    WHERE transaction.declined = 0
    );
#La ejecución de esta consulta nos arroja un total de 292 líneas compuestas por empresas que han tenido transacciones efectivas por un importe superior a la media.

#ejercicio 3:
SELECT company.company_name, transactions.transaction.*
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
WHERE company.company_name LIKE "C%";
#Podemos ver las transacciones que realizaron las compañías cuyo nombre comienza con la letra "C". Tanto las que se han completado como las que han sido declinadas.

#otra opcion de resolución de este ejercicio:
SELECT * 
FROM transactions.transaction
WHERE transaction.company_id IN (
	SELECT id FROM transactions.company WHERE company.company_name LIKE "C%");
#pero en este caso no tenemos los nombres de las compañías

#ejercicio 4:
SELECT company.company_name
FROM transactions.company
WHERE company.id NOT IN (SELECT transaction.company_id FROM transactions.transaction);
#ya han eliminado del listado a las empresas por lo que en esta búsqueda no sale ningún resultado.

##NIVEL 2
#ejercicio 1:
SELECT company.company_name, transactions.transaction.*
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
WHERE company.country = (SELECT company.country FROM transactions.company WHERE company.company_name = "Non Institute");
#Con este resultado vemos todas las transacciones realizadas en el mismo país que la empresa Non Institute, pero en este listado
#también aparecen todas las operaciones de esa empresa. Aparecen 100 líneas como respuesta

#otra opcion de resolución:
SELECT company.company_name, transactions.transaction.*
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
WHERE company.country = (SELECT company.country FROM transactions.company WHERE company.company_name = "Non Institute") 
	AND company.company_name != "Non Institute";
#con esta consulta, aparecen todas las transacciones que son del mismo país de la 
#empresa "non Institute" pero no las que ha realizado esa empresa. Obtenemos 70 líneas retornadas.

#ejercicio 2:
SELECT company.company_name, amount
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
WHERE amount = (SELECT max(amount)
	FROM transactions.transaction);
#Podemos ver que la empresa Nunc Interdum Incorporated ha sido la que ha realizado la transacción por el mayor importe.

##NIVEL 3
#ejercicio 1:
SELECT company.country, AVG(amount)
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
GROUP BY company.country
HAVING avg(amount) > (SELECT avg(amount) FROM transactions.transaction);
#el resultado nos muestra los 5 países en los cuales el promedio de las transacciones es superior a la media de las transacciones.

#ejercicio 2:
SELECT company.company_name, count(transaction.id), count(transaction.id) >4
FROM transactions.company
JOIN transactions.transaction
ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY count(transaction.id) DESC;
#Podemos ver cuáles son las empresas que realizaron más de cuatro transacciones (aparecen con el número 1 en la columna 3). 
#Quise agregar la columna de cantidad de transacciones para confirmar que se han realizado bien los cálculos.