# 25TomaTimer

<div>
<img src="https://user-images.githubusercontent.com/67499943/116644283-e452cc80-a9ad-11eb-863c-67c624e95fa8.png" width="200px">
<img src="https://user-images.githubusercontent.com/67499943/116644288-e74dbd00-a9ad-11eb-858a-c22c1137218d.png" width="200px">
<img src="https://user-images.githubusercontent.com/67499943/116644289-e9b01700-a9ad-11eb-8256-d57047792da4.png" width="200px">
<img src="https://user-images.githubusercontent.com/67499943/116644292-ecab0780-a9ad-11eb-87a7-c6dc12c6db27.png" width="200px">
</div>

## アプリ概要 
ポモドーロタイマーアプリです。

<details>
  <summary>
    参考：ポモドーロ・テクニックとは
  </summary>
  <div>


   ポモドーロ・テクニックとは、作業をする際に使用される時間管理術の一つです。
   
   一つのタスクを25分間続けた後に5分の休憩を取り、そのサイクルを最大4回続けるという時間管理術で、集中力や生産力を高めるために有効とされています。

  </div>
</details>

25分のポモドーロと5分間の休憩、20分間の長い休憩を計測することができます。

時間は変更可能、タイマー終了時アラームを鳴らします。

## アプリURL
https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1565276955

ログイン等は必要ございません。

## 使用技術
- Swift 5.3.2
- Xcode 12.4
- pods
    - MBCircularProgressBar
      - タイマー画面の円形プログレスバー
    - Eureka
      - 設定画面のUI
    - Charts
      - 記録画面の棒グラフ
    - Instructions
      - 初回ログイン時のチュートリアル

## 機能一覧
- タイマー機能
    - スタート/ストップ
    - タイマーリセット
    - バックグラウンドでのタイマー処理
- 記録機能
    - 1日, 10日, 1ヶ月の記録
    - 詳細画面から様々な記録
- 設定機能
    - タイマー時間の設定
    - アラーム音の設定
    - バイブレーションの設定

### タイマー機能
<div>
<img src="https://user-images.githubusercontent.com/67499943/116644283-e452cc80-a9ad-11eb-863c-67c624e95fa8.png" width="200px">
<img src="https://user-images.githubusercontent.com/67499943/116644288-e74dbd00-a9ad-11eb-858a-c22c1137218d.png" width="200px">
<img src="https://user-images.githubusercontent.com/67499943/116644289-e9b01700-a9ad-11eb-8256-d57047792da4.png" width="200px">
</div>

タイマーの基本機能であるスタート, ストップ, 途中でリセットが行えます。

また、バックグラウンドでもタイマーを測り、時間が来るとローカル通知でお知らせ、アラーム音を鳴らします。

タイマーが終了すると、自動的にタイマーの種類を切り替えます。

### 記録機能
<img src="https://user-images.githubusercontent.com/67499943/116644292-ecab0780-a9ad-11eb-87a7-c6dc12c6db27.png" width="200px">

ポモドーロタイマーが動いている時間を計測します。

計測した時間は、Labelの数字と棒グラフで可視化されます。

また、セグメントで「1日毎」「10日毎」「１ヶ月毎」の記録を切り替えて表示します。

詳細画面では、より詳しい情報を数値として見ることができます。

### 設定機能
<img src="https://user-images.githubusercontent.com/67499943/116680283-7080e600-a9e6-11eb-9545-24820b217811.png" width="200px">

以下が設定可能です
- タイマー時間の設定
- アラーム音の設定
- バイブレーションの有無
- ポモドーロタイマー終了時、休憩タイマーに切り替えるかどうか
