#!/bin/bash

echo "ようこそパスワードマネージャーへ！"

read -s -p "パスフレーズを入力してください:" PASSPHRASE
echo " "

while true 
do
	read -p "次の選択肢から入力してください(Add Password/Get Password/Exit):" select


        #Exitが入力された場合
        if [ "${select}" = "Exit" ]; then
	       echo "Thank you!"
	       break



        #Add Passwordが入力された場合
        elif [ "${select}" = "Add Password" ]; then
	       read -p "サービスを入力してください:" service
               read -p "ユーザー名を入力してください:" user
               read -s -p "パスワードを入力してください:" password
               echo " "

	       #既存の暗号化ファイルがある場合に複合化する
	       if [ -f "password_manager.txt.gpg" ];then
		       gpg --batch --passphrase "${PASSPHRASE}" --decrypt password_manager.txt.gpg > password_manager.txt 2>/dev/null
               fi

	       #直前のコマンドが成功したか確認
               if [ $? -ne 0 ];then
		       echo "パスフレーズが違います。"
		       exit 1
	       fi

               #データの追記
               echo "service:${service},user:${user},password:${password}" >> password_manager.txt
	       #再度暗号化して元のファイルを削除
               gpg --batch --yes --passphrase "${PASSPHRASE}" --symmetric -o password_manager.txt.gpg password_manager.txt 2>/dev/null
	       rm password_manager.txt
               echo "パスワードの追加に成功しました"



	#Get Passwordが入力された場合
         elif [ "${select}" = "Get Password" ]; then
               read -p "サービスを入力してください:" service
               result=$(gpg --batch --passphrase "${PASSPHRASE}" --decrypt password_manager.txt.gpg 2>/dev/null | grep "service:${service}")
               
               #パスフレーズの確認
	       if [ $? -ne 0 ];then
		       echo "パスフレーズが違います。"
		       exit 1
	       fi

	       if [ -z "${result}" ]; then
		       echo "そのサービスは登録されていません。"
	       else
		       echo "${result}"
	       fi
	       
	 #入力に誤りがある場合
         else
		 echo "入力が間違えています。Add Password/Get Password/Exitから入力してください。"
       	 fi

done
        	       
