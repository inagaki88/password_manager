#!/bin/bash

echo "ようこそパスワードマネージャーへ！"

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
               echo "service:${service},user:${user},password:${password}" >> password_manager.txt.pgp --batch --passphrase "password" --symmeric password_manager.txt
	       rm password_manager.txt
               echo "パスワードの追加に成功しました"
	#Get Passwordが入力された場合
         elif [ "${select}" = "Get Password" ]; then
               read -p "サービスを入力してください:" service
               result=$(gpg --batch --passphrase "password" --decrypt password_manager.txt.pgp 2>/dev/null | grep "service:${service}")
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
        	       
