# ***Resultados que he ido obteniendo.***

### **Aún no he terminado la serie de este vídeo, mi intención es ir completandola y entender más sobre el cambio climático en Canarias. También me gustaría añadir algún analisis propio. Se me ocurren unos cuantos. Pero tendré que buscar tiempo. Me gustaría buscar en la bibliografía alguna cosa que otra también. ***Tiempo al tiempo*****

Una cosa que si que me gustaría comentar, es que yo no soy de Tenerife, sino de Gran Canaria. Había una estación de NOAA aquí, pero los datos no estaban del todo bien tomados. También me parece que había de otras islas, pero no sé cómo pueden estar tomados las de estas. Pero la realidad es que los datos de Tenerife son muy buenos. En concreto, la estación parece estar en Santa Cruz de Tenerife.

#### **También aviso que el/los secripts están hechos para que se vayan actualizando con el paso del tiempo. Con lo que es muy probable que si copias y pegas el código en tu ordenador local obtengas un resultado más avanzado de que el que esta escrito ahora**


## **1) Existen outliers en nuestra data**

Parece que no hay ningún oulier descarado en cuanto a la teperatura máxima y la temperatura mínima de la base de datos. Si es cierto que en la precipitación, en uno de los últimos años de la década de los 70 hay uno, pero viéndolo, no me sorprendería que fuera un año en el que hubo precipitaciones particularmente altas en Tenerife. 

Más o menos he visto que uno de los años de los 70, sobre el 78 hubo inundaciones en algunas zonas de Tenerife. Mi intención es profundizar más sobre el tema, así que no lo voy a filtrar, al menos por el momento. 

---

<p align="center">
    <img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/outliers.png">
</p>

---


## **2) Variación de de la temperatura máxima en Tenerife**

Vemos que la temperatura en Santa Cruz ha ido aumentando lo que parece de forma significativa significativamente. La línea naranja es la media de de todos los meses de cada año.

Desde mediados de los 40 hasta comienzos de los 70 más o menos, la temperatura estaba entorno a los 19 ºC. Sufriendo un aumento de comienzos de la década anterior hasta más o menos los años 90, donde se mantiene constante salvo en excepciones, al rededor ed entre 20.5-21 ºC. 

---
<p align="center">
    <img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/aumento_tmax.png">
</p>

---

## **3) Variación mensual de la temperatura para cada año hasta el actual**

Hay una posible errata o me estoy perdiendo algo que hice en su momento, pone desde el primer año de estudio (1946) hasta el 2021.

Creo que a lo que me refiero es que las líneas azules son los años en ese abanico. Mientras que en rojo sería el año actual. Lo revisaré en su momento, pero estoy casi seguro que es lo anterior. Igualmente tendré que campiarlo por que desta manera el gráfico se quedaría obsoleto el año que viene en el script (se modifica automáticamente).

Una cosa a destacar de la figura es que obviamente el eje "y" no se refiere a la temperatura que hubo en ese día, si no que se normalizaron los datos para que muestre la diferencia del aumento de la temperatura máxima. Es decir, en los años que se encuentran por debajo del 0, sería los que han disminuido en esta, mientras que los años que se encuentren por encima de este, son los que han aumentado.

En Rojo se mostraría el año actual, el cuál es un año muy caluroso. 

---

<p align="center">
    <img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/variacion_mensual.png">
</p>

---

### **4) Variación en la precipitación anual**

El gráfico, funciona de manera similar que el de arriba, muestra la distribución de la precipitación acumulada, es decir del total que ha llovido, en este caso en cada mes del año en mm^3. 

Podemos ver que en lo que vamos de año (el día que hago por primera vez este documento es el 16 de sep de 2022) se trata de uno especialmente seco, por debajo de la tendiencia central.

Parece ser que de los meses de febrero a abril lluve considerablemente, pero de este a octubre las presipitaciones son constantes, y en otoño vuelven a aumentar bastante. 

Para que no haya confusión, el gráfico no dice que verano tiene más precipitación que enero-junio, si no que es lo que muestra la lluvia que se va acumulando cada mes hasta el último.

---

<p align="center">
<img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/variacion_emnsual_precipitacion.png">
</p>

---

Por otro lado, el siguente gráfico muestra esta vez, lo que ha llovido de cada mez, no la precipitación aculumada. 

La intención era estudiar un año especialmente seco, en este caso el año 1973.

Los resultados tal y como están ahora, muestran que el verano de ese año fue especialmente seco. La precipitación de julio a agosto/~septiembre fue menor que el 95 % de los años anteriores desde 1946.

---

<p align="center">
<img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/anio_mas_seco.png">
</p>

---

### **5) Variación de la temperatura máxima y la precipitación acumulada.**

Como ya se dijo en su momento, la línea naranja sigue representando el promedio de la temperatura máxima de cada año. Pero para el caso de la precipitación, el que se ha calculado es la acumulación de esta, es decir, el total de lo llovido en mm.

Podemos ver que una de las razones por las sentimos tanto calor estos últimos años puede explicarse por no sólo el aumento de la temperatura, si no que parece además que los años son cada vez más secos.

---

<p align="center">
    <img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/temp_vs_prec.png">
</p>

---

Al hacer la correlación entre ambas variables podemos ver que existe una cierta correlación negativa entre ambas

---

<p align="center">
    <img src="https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/correlacion.png">
</p>

---

### **6) Probabilidad de lluvia**

Aquí es hasta donde he llegado, y es un gráfico que me gusta bastante. El primero muestra la probabilidad que llueva en el eje de las y. El segundo el promedio de la precipitación diraria y por último el promedio de lo que llovería por evento. 

Además, en el eje de las x encontraríamos el mes y la línea roja que corta el axis sería el día de hoy.

---

<p align="center">
    <img src= "https://github.com/Juankkar/Tiempo_Tenerife/blob/main/graficos/probabilidad_prec.png">
</p>

---
