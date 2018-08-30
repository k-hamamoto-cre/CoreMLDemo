# CoreMLデモアプリケーション

<h2>＜ビルド方法＞</h2>
  <h3>(0)ビルド環境</h3>
    <ul>
  <li>Mac OS：10.13.5</li>
  <li>Xcode：9.4.1</li>
    </ul>
  
  <h3>（1）以下のAppleのサイトから作成済みのmlmodelファイルをダウンロードする</h3>
      <h4>https://developer.apple.com/jp/machine-learning/build-run-models/</h4>
      
      ※2018/8/30現在、ページの下の方にDLコーナーあり
      ※DLするモデルはどれでもOK
      ※IBM Watsonのサービスから自前で作成してもOK
      
  <h3>(2)ローカルにクローンorDLしたプロジェクトをxcodeで開き、事前に取得したmlmodelファイルをプロジェクト上に追加する(プロジェクトナビゲータ上にD&Dする)</h3>
     
      ※ドロップする場所の指定はないが、AppDelegate.swiftと同じ階層とかにドロップしておく
     
  <h3>(3)プロジェクトナビゲータから[CoreMLDemo]->[Utility]->CoreMLUtility.swiftを開く</h3>
  
  <h3>(4)ソース上のコメントに従い、VNCoreMLModel作成時に使用しているクラス名を、
  　　　　　　追加したmlmodelファイルのファイル名に書き換える。</h3>
     
     ※mlmodelファイルの追加が上手くできていれば、クラス名の書き換え中にサジェスト表示される
  
  <h3>(5)必要であればプロジェクトの設定からSigning周りを修正して実機にビルドする。</h3>
  
      ※プロビショニングプロファイルや証明書の選択
