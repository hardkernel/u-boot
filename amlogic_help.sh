# print amlogic board config

if [ -z ${srctree} ]; then
	srctree=`pwd`
fi

folder_board=${srctree}"/board/amlogic"

#echo $folder_board
#ls -a ${folder_board}

echo ""
echo "**************Amlogic Configs**************"
echo "*                                         *"
echo "*          ./mk (config_name)             *"
echo "*                                         *"
echo "*******************************************"

for file in ${folder_board}/*; do
	temp_file=`basename $file`
	#echo "$temp_file"
	if [ -d ${folder_board}/${temp_file} ] && [ "$temp_file" != "defconfigs" ] && [ "$temp_file" != "configs" ];then
		printf "\t$temp_file\n"
	fi
done

echo "*******************************************"

customer_folder=${srctree}"/customer/board"
if [ -e ${customer_folder} ];then
	echo "**************Customer Configs*************"
	for file in ${customer_folder}/*; do
		temp_file=`basename $file`
		if [ -d ${customer_folder}/${temp_file} ] && [ "$temp_file" != "defconfigs" ] && [ "$temp_file" != "configs" ];then
			printf "\t$temp_file\n"
		fi
	done
	echo "*******************************************"
fi
