#!/bin/bash

set +e
current_dir=$(cd `dirname $0` && pwd)   #当前工作目录

#Harbor仓库信息
harbor_ip=172.16.38.202
harbor_port=8010
harbor_user=admin
harbor_pwd=admin
harbor_project=lnmp

set -e
docker login http://${harbor_ip}:${harbor_port} -u admin -p admin
#构建镜像
Build_Image(){
    image_name=nginx-php-fpm
    image_tag=ver1.0_$(date "+%Y%m%d")
    image_path=${harbor_ip}:${harbor_port}/${harbor_project}/${image_name}:${image_tag}
    cd ${current_dir}/dockerfiles/nginx/
    docker build -t ${image_path} .
    docker push ${image_path}
}


Update_Compose(){
    compose_module_file=${current_dir}/docker-compose-module.yml
    compose_file=${current_dir}/docker-compose.yml
    \cp ${compose_module_file} ${compose_file}
    #local base_tag=$1		#jenkins传进来的参数
    new_tag=${image_path}
    base_tag=$(sed -n '/#tag#/p' ${compose_file} |awk -F'#' '{print $3}')	#提取docker-compose.yml的镜像tag
    sed -ri "/#tag#/ s@^(.*)(#tag#)(.*)@\1${new_tag}@" ${compose_file}		#替换为新的tag
}

######################主函数######################
Build_Image
Update_Compose

set +e
