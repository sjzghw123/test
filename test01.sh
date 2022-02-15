#!/bin/bash


ip=`grep -i 'ip=' weblogic_oa_wls_192.168.3.107_20220121101904.txt |awk -F '=' '{print $2}'`


ps_info_start_num=`grep -n 'ps-weblogic-info-start' weblogic_oa_wls_192.168.3.107_20220121101904.txt | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `
ps_info_end_num=`grep -n 'ps-weblogic-info-end' weblogic_oa_wls_192.168.3.107_20220121101904.txt | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `
ps_info_start_num=`expr $ps_info_start_num + 1 `
ps_info_end_num=`expr $ps_info_end_num - 1` 


pids=`sed -n ' '$ps_info_start_num','$ps_info_end_num' 'p' ' weblogic_oa_wls_192.168.3.107_20220121101904.txt | awk '{print $2}' `

for pid in $pids
do
    #echo $pid | tr -d '\r'

    pid_start_num=`grep -n "$pid-start"  weblogic_oa_wls_192.168.3.107_20220121101904.txt | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `
    pid_end_num=`grep -n "$pid-end"  weblogic_oa_wls_192.168.3.107_20220121101904.txt | awk -F ':' '{print $1}' | cut -d ' ' -f 4`
    
    pid_start_num=`expr $pid_start_num + 1 `
    pid_end_num=`expr $pid_end_num - 1` 
    
    #echo $pid_start_num 
    #echo $pid_end_num
    
     
    domain_name=`sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt   | grep 'domain_name'  | awk -F '=' '{print $2}'`
    server_name=`sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt   | grep 'server_name'  | awk -F '=' '{print $2}'`

    new_document=$ip.txt
    echo "#################weblogic基础信息及配置信息######################" >>  $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'domain_name' >> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'domain_dir' >> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'domain_version'>> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'java_version' >> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'weblogic_dir' >> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'server_name' >> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'server_port' >> $new_document
    sed -n  ' '$pid_start_num','$pid_end_num' 'p' '    weblogic_oa_wls_192.168.3.107_20220121101904.txt  | grep 'server_jvm' >> $new_document


    
    ##get app deployment
    #get <>
    #app_start_num=`grep -n '<app-deployment>' config.xml | head -n 1 | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `
    #app_end_num=`grep -n '</app-deployment>' config.xml | tail -n 1 | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `


    #appinfo=`sed -n  ' '$app_start_num','$app_end_num' 'p' ' config.xml | grep -oP '(?<=name>)[^<]+' ` 
    #appinfo=`sed -n  ' '$app_start_num','$app_end_num' 'p' ' config.xml | grep 'name' | awk 'BEGIN{FS=">";RS="</"}{print $NF}' | sed '/^\(\s\)*$/d' `
    #echo appinfo=`echo $appinfo | sed 's/[ ][ ]*/,/g' `

    cd ${domain_name}_${server_name}_${pid}
    app_start_num=`grep -n '<app-deployment>' config.xml | head -n 1 | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `
    app_end_num=`grep -n '</app-deployment>' config.xml | tail -n 1 | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `


    appinfo=`sed -n  ' '$app_start_num','$app_end_num' 'p' ' config.xml | grep -oP '(?<=name>)[^<]+' ` 
    #appinfo=`sed -n  ' '$app_start_num','$app_end_num' 'p' ' config.xml | grep 'name' | awk 'BEGIN{FS=">";RS="</"}{print $NF}' | sed '/^\(\s\)*$/d' `


    echo appinfo=`echo $appinfo | sed 's/[ ][ ]*/,/g' `


    
    jdbc_start_num=`grep -n '<jdbc-system-resource>' config.xml | head -n 1 | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `
    jdbc_end_num=`grep -n '</jdbc-system-resource>' config.xml | tail -n 1 | awk -F ':' '{print $1}' |cut -d ' ' -f 4 `

    #jdbcinfo=`sed -n  ' '$jdbc_start_num','$jdbc_end_num' 'p' ' config.xml | grep -oP '(?<=name>)[^<]+' ` 
    jdbcinfo=`sed -n  ' '$jdbc_start_num','$jdbc_end_num' 'p' ' config.xml | grep '<name>' | awk 'BEGIN{FS=">";RS="</"}{print $NF}' | sed '/^\(\s\)*$/d' `

    for jdbc in $jdbcinfo
    do
        echo $jdbc
        grep 'url' $jdbc-*.jdbc.xml    
    
    done
    cd ..
    
    
done
