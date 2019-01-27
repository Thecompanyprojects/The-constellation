

# 使用方法:
# step1 : 将AutoPackageScript整个文件夹拖入到项目主目录,项目主目录,项目主目录~~~(重要的事情说3遍!😊😊😊)
# step2 : 打开AutoPackageScript.sh文件,修改 "项目自定义部分" 配置好项目参数
# step3 : 打开终端, cd到AutoPackageScript文件夹 (ps:在终端中先输入cd ,直接拖入AutoPackageScript文件夹,回车)
# step4 : 输入 sh AutoPackageScript.sh 命令,回车,开始执行此打包脚本

# ===============================项目自定义部分(自定义好下列参数后再执行该脚本)============================= #
# 计时
SECONDS=0
# 是否编译工作空间 (例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
is_workspace="true"
# 指定项目的scheme名称
# (注意: 因为shell定义变量时,=号两边不能留空格,若scheme_name与info_plist_name有空格,脚本运行会失败,暂时还没有解决方法,知道的还请指教!)
scheme_name="XToolConstellationIOS"
# 工程中Target对应的配置plist文件名称, Xcode默认的配置文件为Info.plist
info_plist_name="Info"
# 指定要打包编译的方式 : Release,Debug...
build_configuration="Release"


# 蒲公英账户设置
pgyer_uKey="04e0aa9bf1bf3934922473d182b686cd"
pgyer_api_key="492f468f229cf8478f37054e149cc082"

# Fir.im账户设置
fir_APIToken="164a43bd92b8cfa78c6929b0ba9bf5b0"









# ===============================自动打包部分(无特殊情况不用修改)============================= #

# 导出ipa所需要的plist文件路径 (默认为AdHocExportOptionsPlist.plist)
ExportOptionsPlistPath="./AutoPackageScript/AdHocExportOptionsPlist.plist"
# 返回上一级目录,进入项目工程目录
cd ..
# 获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
# 获取版本号,内部版本号,bundleID
InfoPlistPath="$project_name/Resources/$info_plist_name.plist"  #info.plist文件路径一定不能出错
bundle_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $InfoPlistPath`
bundle_build_version=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $InfoPlistPath`
bundle_identifier=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $InfoPlistPath`
bundle_display_name=`/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" $InfoPlistPath`

# 删除旧.xcarchive文件
rm -rf ~/Desktop/$scheme_name-IPA/$scheme_name.xcarchive
# 指定输出ipa路径
export_path=~/Desktop/$scheme_name-IPA
# 指定输出归档文件地址
export_archive_path="$export_path/$scheme_name.xcarchive"
# 指定输出ipa地址
export_ipa_path="$export_path"
# 指定输出ipa名称 : scheme_name + bundle_version
ipa_name="$bundle_display_name-v$bundle_version-$bundle_build_version"


ExportOptionsPlistPath="./AutoPackageScript/AdHocExportOptionsPlist.plist"


echo "\n\n\033[34;1m*******************  开始编译代码...  *******************\033[0m"



# 指定输出文件目录不存在则创建
if [ -d "$export_path" ] ;
then
echo $export_path
else
mkdir -pv $export_path
fi



# 判断编译的项目类型是workspace还是project
if $is_workspace ;
then
# 编译前清理工程
xcodebuild clean -workspace ${project_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -workspace ${project_name}.xcworkspace \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}
else
# 编译前清理工程
xcodebuild clean -project ${project_name}.xcodeproj \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -project ${project_name}.xcodeproj \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}
fi





#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
echo "\033[32;1m项目构建成功 ✅  ✅  ✅ \033[0m"
else
echo "\033[31;1m项目构建失败 ❌  ❌  ❌  \033[0m"
exit 1
fi



echo "\n\n\033[34;1m*******************  开始导出ipa文件...  *******************\033[0m"

xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${ExportOptionsPlistPath}
# 修改ipa文件名称
mv $export_ipa_path/$scheme_name.ipa $export_ipa_path/$ipa_name.ipa


# 上传ipa包至蒲公英
function upload_pgyer()
{
curl -F "file=@$export_ipa_path/$ipa_name.ipa" \
-F "uKey=$pgyer_uKey" \
-F "_api_key=$pgyer_api_key" \
https://www.pgyer.com/apiv1/app/upload
}

# 上传ipa包至Fir
function upload_fir()
{
fir login -T $fir_APIToken
fir publish $export_ipa_path/$ipa_name.ipa
}



# 检查文件是否存在
if [ -f "$export_ipa_path/$ipa_name.ipa" ] ;
    then
    echo "\033[32;1m导出 ${ipa_name}.ipa 包成功 ✅  ✅  ✅  \033[0m"
    open $export_path


    echo "\n\n\033[34;1m*******************  开始上传至蒲公英...  *******************\033[0m"
    result=$(upload_pgyer)
    echo $result
    if [ ! -n "$result" ];
        then
            echo "\n\033[31;1m上传至蒲公英失败 ❌  ❌  ❌  \033[0m"
            exit 1
        else
            echo "\n\033[32;1m上传至蒲公英成功 ✅  ✅  ✅  \033[0m"
            echo "\n\n\033[32;1m蒲公英测试包下载地址:https://www.pgyer.com/horoscope\033[0m"
            open -a "/Applications/Safari.app" https://www.pgyer.com/horoscope

#        echo "\n\n\033[32;1m请输入本次更新内容,点击回车发送邮件, 结束请输入0  \033[0m\n"
#        read update_content
#            if [ $update_content == 0 ];
#                then
#                    exit 1
#                else
#                    echo "\n\033[32;1m邮件发送中....  \033[0m\n\n"
#                python sendEmail.py "iOS测试版本 $ipa_name 打包成功" "<p>Horoscope 测试版已经打包并上传完成;<br><b style=\"color:red\">本次更新内容:</b><br>$update_content <br><br><a href=\"https://www.pgyer.com/horoscope\">下载链接</a><br><br>如有 BUG 请及时反馈!谢谢!</p>"
#            fi
    fi




else
    echo "\033[31;1m导出 ${ipa_name}.ipa 包失败 ❌  ❌  ❌  \033[0m"
    exit 1
fi

# 输出打包总用时
echo "\n\n\n\033[32;1m本次 打包+上传ipa测试包 总用时: ${SECONDS}s\033[0m"


