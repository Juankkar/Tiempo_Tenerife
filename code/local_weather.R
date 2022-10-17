library(tidyverse)
library(glue)
library(lubridate)
library(ggthemes)
library(ggtext)
library(cowplot)


inventory_url <- "https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt"

inventory <- read_table(inventory_url,
                        col_names = c("Station", "lat", "lon", "variable", "start", "end"))

# Tenerife
my_lat <- 28.491067570987454 * 2 * pi / 360
my_lon <- -16.315565584795802* 2*  pi / 360


my_station <- inventory %>% 
  mutate(lat_r = lat*2*pi/360,
         lon_r = lon*2*pi/360,
         d = 1.609344 * 3963 * acos((sin(lat_r)*sin((my_lat)) + cos(lat_r) * cos(my_lat) * cos(my_lon - lon_r)))) %>% 
  filter(start < 1960 & end > 2020) %>% 
  top_n(n = -1, d) %>% 
  distinct(Station) %>% 
  pull(Station)

my_station_url <- glue("https://www.ncei.noaa.gov/pub/data/ghcn/daily/by_station/{my_station}.csv.gz")

local_weather <- read_csv(my_station_url,
         col_names = c("station","date","variable","value","a","b","c","d")) %>% 
  select(date,variable,value) %>%
  pivot_wider(names_from = "variable",values_from = "value") %>% 
  select(date,tmax=TMAX,tmin=TMIN,prcp=PRCP)  %>% 
  mutate(date=ymd(date),
         tmax = tmax/10,
         tmin = tmin/10,
         prcp=prcp/10
         # tmax = if_else(tmax != 0, tmax, NA_real_),
         # tmin = if_else(tmin != 0, tmin, NA_real_)
  )
  # filter(year(date) > 1973 &
  #          year(date) < 2016
  #        ) %>%

#### Estudiaremos con el siguiente código la existencia de outliers. No parecen haber
## Resultados tan exagerados como para filtrarlos en mi opinión en la precipitación (prcp)
## Hay un valor atípico en uno de los años, pero me parece interesante dejarlo, porque
## parece coincidir con una inundación de finales de los 70.

outliers1 <- local_weather %>%
  ggplot(aes(date, tmax)) +
  geom_line() +
  labs(title = "¿Outliers Temperatura máxima?",
       x = "Fecha",
       y = "Temperatura máxima")

outliers2 <- local_weather %>%
  ggplot(aes(date, prcp)) +
  geom_line() +
  labs(title = "¿Outliers Precipitación?",
       x = "Fecha",
       y = "Precipitación")

outliers3 <- local_weather %>%
  ggplot(aes(date, tmin)) +
  geom_line() +
  labs(title = "¿Outliers Temperatura mínima?",
       x = "Fecha",
       y = "Temperatura mínima")

# Vamos a utilizar cowplot y tener todos estos resultados en un único gráfico.

plot_grid(outliers1, outliers2, outliers3)

ggsave("outliers.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=5)

#------------------------------------------------------------------------------#
#                       Estudio de la tmax                                     #
#------------------------------------------------------------------------------#

this_year <- year(today())

local_weather %>%
  drop_na() %>% 
  select(date, tmax) %>% 
  mutate(year = year(date)) %>% 
  filter(year > 1945 & year != this_year) %>% 
  group_by(year) %>% 
  summarize(tmax=mean(tmax)) %>%
  mutate(normalize_range = (year >= 1945 & year <=1980),
         normalize_mean = sum(tmax*normalize_range)/sum(normalize_range),
         t_diff = tmax - normalize_mean) %>% 
  ggplot(aes(year, tmax)) +
  geom_line(col="orange", size=1) +
  geom_smooth(color="blue") +
  scale_x_continuous(limits = c(1946,2022),
                     breaks = seq(1950,2022,10)) +
  labs(x="Año",
       y="ºC",
       title = "Aumento de los ºC en Canarias",
       subtitle= "Estación meteorológica de Santa Cruz de Tenarife") +
  #theme_classic() +
  theme(
    #panel.grid = element_blank(),
    #axis.line = element_(color = "white"),
    panel.background = element_rect(fill="black", color="white"),
    plot.background = element_rect(fill="black", color="black"),
    title = element_text(color="white"),
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    axis.text = element_text(color = "white")
  )
ggsave("aumento_tmax.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=4)

local_weather %>% 
  drop_na() %>% 
  select(date, tmax) %>% 
  mutate(year = year(date),
         month = month(date)) %>% 
  filter(year > 1945) %>% 
  group_by(year, month) %>% 
  summarise(tmax=mean(tmax), .groups = "drop") %>% 
  group_by(month) %>% 
  mutate(normalized_range = year >= 1945 & year <= 1980,
         normalized_temp = sum(tmax * normalized_range)/sum(normalized_range),
         t_diff = tmax-normalized_temp,
         is_this_year = year == this_year) %>% 
  ungroup() %>% 
  ggplot(aes(month, t_diff,
             color=is_this_year,
             color=year,
             group = year)) +
  geom_line(size=1) +
  scale_x_continuous(limits = c(0,13),
                     breaks = seq(1,12,1)) +
   scale_color_manual(breaks = c(F,T),
                      values = c("lightblue", "red"),
                      guide=NULL) +
  labs(
    title = "Variación mensual de la temperatura con el paso de los años",
    subtitle = "Rojo: año actual, azul: resto de años (1946-2021)",
    y = "Grados Centígrados",
    x = "Meses"
  ) +
  theme(
    panel.background = element_rect(fill="black", color="black"),
    plot.background = element_rect(fill="black", color="black"),
    title = element_text(color="white"),
    plot.title = element_text(hjust = .5),
    plot.subtitle = element_text(hjust = .5)
  )

ggsave("variacion_mensual.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=4)

#------------------------------------------------------------------------------#
#                            Has been this year weeter?                       #
#------------------------------------------------------------------------------#



local_weather %>% 
  drop_na %>% 
  select(date,prcp) %>% 
  drop_na(prcp) %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date),
         is_this_year = year == this_year) %>% 
  filter(year > 1945 & !(month == 2 & day == 29)) %>% 
  group_by(year) %>% 
  mutate(cum_prcp = cumsum(prcp)) %>% 
  ungroup() %>% 
  mutate(new_date = ymd(glue("2020-{month}-{day}"))) %>% 
  ggplot(aes(new_date, cum_prcp, color = is_this_year, group=year, size = is_this_year)) +
  geom_line(show.legend = F) +
  geom_smooth(aes(group=1), color="black", show.legend = F) +
  scale_size_manual(breaks = c(F,T),
                    values = c(.5,2)) +
  scale_color_manual(breaks = c(F,T),
                     values = c("gray", "red"),
                     guide=NULL) +
  scale_y_continuous(expand = expansion(0)) +
  labs(
    title = glue("Variación en la precipitación acumulada con el paso de los años"),
    subtitle = glue("<span style = 'color: red'>Año {this_year}</span>, <span style = 'color: darkgray'> y resto de años</span> (1946-{this_year-1})\nTenerife, Islas Canarias"),
    y = "Precipitación acumulada",
    x = "Tiempo (meses)"
  ) +
  theme_classic() +
  scale_x_date(date_labels = "%B",
               date_breaks = "2 months") +
  theme(
    # axis.line = element_line(color = "white"),
    # panel.background = element_rect(fill="black", color="black"),
    # plot.background = element_rect(fill="black", color="black"),
    title = element_text(color="black"),
    plot.title = element_text(hjust = .5, face = "bold"),
    plot.subtitle = element_markdown(hjust = .5, face = "bold")
  )

ggsave("variacion_emnsual_precipitacion.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=4)

#------------------------------------------#
# Estudio de correlación usando facet wrap #
#------------------------------------------#

tmax_prcp <- local_weather %>% 
  mutate(year = year(date)) %>%
  filter(year > 1945 & year != this_year) %>%
  group_by(year) %>%
  summarise(tmax = mean(tmax, na.rm = T),
            prcp = sum(prcp, na.rm = T))

tmax_prcp %>% 
  pivot_longer(-year, names_to = "categoria", values_to = "valor") %>% 
  ggplot(aes(year, valor, color=categoria)) +
  geom_line(size=1,show.legend = F) +
  facet_wrap(~categoria, ncol=1, scales = "free_y") +
  geom_smooth(se=F,show.legend = F, color="blue") +
  scale_color_manual(breaks = c("prcp", "tmax"),
                     values = c("orange","skyblue"))


tmax_prcp %>% 
  mutate(
    tmax_tr = (tmax - min(tmax))/ (max(tmax)- min(tmax)),
    tmax_min = min(tmax),
    tmax_max = max(tmax),
    
    prcp_tr = (prcp - min(prcp))/ (max(prcp)- min(prcp)),     
    prcp_min = min(prcp),
    prcp_max = max(prcp)
         ) %>% 
  ggplot(aes(year, tmax_tr)) +
  geom_line(color="orange", size=1) +
  geom_line(aes(y = prcp_tr), size= 1, color = "skyblue") +
  labs(title = "Tenperatura máxima y prescipitacion acumulada anual",
       subtitle = "Estación meteorológica Santa Cruz de Tenerife, Islas Canarias",
       x = "Año",
       y = "Temperatura máxima (ºC)") +
  scale_y_continuous(labels = seq(17,23, 1),
                     breaks = (seq(17,23,1) - 17.9)/(21.9-17.9),
                     limits = (c(17,23)- 17.9)/(21.9-17.9),
                     sec.axis = sec_axis(trans = ~.,
                                         labels = seq(120,1400, 300),
                                         breaks = (seq(120,1400, 300)-299)/(1102-299),
                                         name = "Presipitación (mm)")) +
  theme(
    panel.background = element_rect(fill = "black", color = "white"),
    plot.background  = element_rect(fill = "black", color = "black"),
    panel.grid = element_blank(),
    title = element_text(color="white"),
    plot.title = element_text(face="bold", hjust = .5),
    plot.subtitle = element_text(hjust = .5),
    axis.text = element_text(color="white"),
    axis.title.y.right = element_text(color = "skyblue"),
    axis.text.y.right = element_text(color = "skyblue"),
    axis.title.y.left = element_text(color = "orange"),
    axis.text.y.left = element_text(color = "orange")
    )

ggsave("temp_vs_prec.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=4.5)

tmax_prcp %>% 
  ggplot(aes(tmax, prcp)) +
  geom_point() +
  geom_smooth(method = "lm", se=F)

ggsave("correlacion.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=4)

cor.test(tmax_prcp$tmax, tmax_prcp$prcp, method = "spearman")

#------------------------------------------------------------------------#
# Figuras chulas con facet wrap y sacar la probabilidad de precipitación #
#------------------------------------------------------------------------#

today_month <- month(today())
today_day <- day(today())
today_date <- ymd(glue("2020-{today_month}-{today_day}"))

pretty_label <- c("prob_prcp" = "Probabilidad de precipitación", 
                  "mean_prcp" = "Promedio de precipitación\ndiaria (mm)",
                  "mean_event" = "Promedio de precipitación\npor evento (mm)")

local_weather %>% 
  select(date, prcp) %>% 
  mutate(day = day(date),
         month = month(date),
         year = year(date)) %>% 
  drop_na(prcp) %>% 
  group_by(month, day) %>% 
  summarise(prob_prcp = mean(prcp > 0),
            mean_prcp=mean(prcp),
            mean_event = mean(prcp[prcp > 0]),
            .groups = "drop") %>% 
  mutate(date=ymd(glue("2020-{month}-{day}"))) %>% 
  select(-month,-day) %>% 
  pivot_longer(cols = c(prob_prcp, mean_prcp, mean_event)) %>% 
  mutate(name=factor(name, levels = c("prob_prcp", "mean_prcp", "mean_event"))) %>% 
  ggplot(aes(date, value)) +
  geom_line(size=.55) +
  geom_smooth(se=F) +
  geom_vline(xintercept = today_date, size=1, color="red",linetype="dashed") +
  facet_wrap(~name, ncol=1, 
             scales = "free_y",
             strip.position = "left",
             labeller = labeller(name=pretty_label)) +
  scale_y_continuous(limits = c(0,NA), expand = expansion(0)) +
  scale_x_date(date_labels = "%B", 
               date_breaks = "2 months") +
  coord_cartesian(clip="off") +
  labs(
    x=NULL,
    y=NULL
  ) +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(),
    strip.placement  = "outside",
    strip.background = element_blank()
  )

ggsave("probabilidad_prec.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =8, height=5.5)

#-------------------------------------------------------------------------------------#
# Creating a sliding window with the slider R package to quantify the level of drought#
#----------------------------------------------------------------------------------------------#
library(slider)

drougth_data<-local_weather %>% 
  select(date, prcp) %>% 
  mutate(prcp = ifelse(is.na(prcp), 0, prcp)) %>% 
  arrange(date) %>% 
  mutate(window_prcp = slide_dbl(prcp, ~sum(.x), 
                                 .before=99, .complete=T)) %>% 
  drop_na(window_prcp) %>% 
  mutate(start=date-29) %>% 
  select(start, end=date, window_prcp) %>% 
  mutate(end_month=month(end),
         end_day=day(end),
         end_year=year(end)) %>%  
  group_by(end_month, end_day) %>% 
  mutate(threshold= quantile(window_prcp, prob=0.05)) %>% 
  ungroup()

drougth_line <- drougth_data %>% 
  select(end_month, end_day, threshold) %>% 
  distinct() %>% 
  mutate(fake_date= ymd(glue("2020-{end_month}-{end_day}"))) 

driest_year <- drougth_data %>% 
  filter(end_month == 7) %>% 
  filter(window_prcp == min(window_prcp)) %>% 
  group_by(end_year) %>% 
  select(end_year) %>% count()


drougth_data %>% 
  mutate(fake_date= ymd(glue("2020-{end_month}-{end_day}")),
         is_drougth_year = end_year == driest_year$end_year,
         drougth_year = end_year == threshold,
         end_year=fct_reorder(factor(end_year), is_drougth_year)) %>% 
  select(-start, -end) %>% 
  ggplot(aes(fake_date, window_prcp, group=end_year, 
             color=is_drougth_year, size=is_drougth_year)) +
  geom_line(show.legend = F) +
  geom_line(data=drougth_line, aes(x =fake_date, y=threshold), 
            color="red", inherit.aes = F, size=1) +
  scale_color_manual(breaks=c(T,F),
                     values=c("blue","gray")) +
  scale_size_manual(breaks = c(T,F),
                    values = c(1,.5)) +
  scale_x_date(date_breaks = "2 months", date_labels = "%B") +
  labs(
    title = glue("El verano de <span style = 'color: blue'>{driest_year$end_year}</span> tuvo menos precipitaciones que el<br><span style = 'color: red'>95% de los años anteriores desde 1946</span>"),
    x = "Date",
    y = "Precipitación total en los 100\ndías previos (mm)"
  ) +
  theme_classic() +
  theme(
    # axis.line = element_line(color = "white"),
    # panel.background = element_rect(fill="black", color="black"),
    # plot.background = element_rect(fill="black", color="black"),
    title = element_markdown(color="black"),
    plot.title = element_markdown(hjust = .5, face = "bold", 
                                  margin = margin(b=20)),
    plot.subtitle = element_markdown(hjust = .5, face = "bold")
  )

ggsave("anio_mas_seco.png", path = "C:\\Users\\jcge9\\Desktop\\cuarto_carrera\\Tiempo_Tenerife\\graficos",
       width =7, height=4)


