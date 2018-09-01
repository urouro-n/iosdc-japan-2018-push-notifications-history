package main

import (
	"fmt"
	"log"
	"os"

	"github.com/sideshow/apns2"
	"github.com/sideshow/apns2/token"
)

func main() {

	authKey, err := token.AuthKeyFromFile(os.Getenv("APN_AUTH_KEY_FILE"))
	if err != nil {
		log.Fatal("token error:", err)
	}

	token := &token.Token{
		AuthKey: authKey,
		KeyID:   os.Getenv("APN_KEY_ID"),
		TeamID:  os.Getenv("APN_TEAM_ID"),
	}

	// 本文
	payload := []byte(`
		{
			"aps": {
				"alert": "Hello!",
				"badge": 0,
				"sound": "default"
			}
		}
	`)

	// サイレントプッシュ通知
	// payload := []byte(`
	// 	{
	// 		"aps": {
	// 			"content-available": 1
	// 		},
	// 		"example_content_id": 123
	// 	}
	// 	`)

	// カスタムアクション
	// payload := []byte(`
	// 	{
	// 		"aps": {
	// 			"alert": "カスタムアクションつきリモート通知",
	// 			"category": "EXAMPLE"
	// 		}
	// 	}
	// `)

	// title, subtitleの指定
	//payload := []byte(`
	//	{
	//		"aps": {
	//			"alert": {
	//				"title": "カスタムアクションつきリモート通知",
	//				"subtitle": "サブタイトル",
	//				"body": "本文本文本文..."
	//			},
	//			"sound": "default",
	//			"category": "EXAMPLE"
	//		}
	//	}
	//`)

	// Notification Content Extension用
	//payload := []byte(`
	//	{
	//		"aps": {
	//			"alert": {
	//				"title": "テストタイトル",
	//				"subtitle": "テストサブタイトル",
	//				"body": "テスト本文"
	//			},
	//			"sound": "default",
	//			"category": "EXAMPLE_CONTENT"
	//		}
	//	}
	//`)

	// Notification Service Extension用
	//payload := []byte(`
	//	{
	//		"aps": {
	//			"alert": {
	//				"title": "タイトル",
	//				"subtitle": "サブタイトル",
	//				"body": "本文です本文です本文です本文です本文です本文です本文です"
	//			},
	//			"sound": "default",
	//			"category": "EXAMPLE",
	//			"mutable-content": 1
	//		},
	//		"photo_url": "https://s3-ap-northeast-1.amazonaws.com/urouro.net-example/push-notification-history/photo1.jpg"
	//	}
	//`)

	// thread-idの設定
	// たとえば通知をプレビューしない設定にしたとき, 同一の thread-id の通知がまとめられる
	//payload := []byte(`
	//	{
	//		"aps": {
	//			"alert": {
	//				"title": "テストタイトル",
	//				"subtitle": "サブタイトル",
	//				"body": "本文本文本文..."
	//			},
	//			"sound": "default",
	//			"category": "EXAMPLE",
	//			"thread-id": "example-thread-1"
	//		}
	//	}
	//`)

	notification := &apns2.Notification{
		DeviceToken: os.Getenv("DEVICE_TOKEN"),
		Topic:       "net.urouro.PushNotificationsHistory",
		Payload:     payload,

		// apns-collapse-id ヘッダ。
		// 同種の通知を1つに併合する。removeDeliveredNotificationsで削除するときに指定するidentifierにもなる。
		//CollapseID:  "REMOTE_EXAMPLE",
	}

	client := apns2.NewTokenClient(token)
	res, err := client.Push(notification)

	if err != nil {
		log.Fatal("Error:", err)
	}

	fmt.Printf("%v %v %v\n", res.StatusCode, res.ApnsID, res.Reason)
}
