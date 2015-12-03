# print amlogic board config

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
	if [ -d ${folder_board}/${temp_file} ];then
		echo "	\c"
		echo $temp_file
	fi
done

echo "*******************************************"