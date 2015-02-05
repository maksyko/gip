# Приложение для конвертирования Ip адрес в гео-кординаты
### Запрос
```
    gip_worker:get_geo_coordinates(<<"54.76.91.175">>).
```
### Ответ
```
    {ok,[{<<"country_code">>,<<"US">>},
         {<<"city">>,<<"Woodbridge">>}]}
```

### Запрос
```
    gip_worker:get_geo_coordinates(<<"54.76.91!175">>).
```
### Ответ
```
    {error,wrong_format_data}
```
