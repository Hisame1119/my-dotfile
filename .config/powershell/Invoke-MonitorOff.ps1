# ディスプレイの電源をオフにする関数
function Invoke-MonitorOff {
  <#
  .SYNOPSIS
  全てのユーザー入力を一時的にブロックし、ディスプレイの電源をオフにします。
  これにより、入力ノイズによる即時復帰を防ぎます。
  #>

  # ユーザー入力（マウス/キーボード）をブロック/解除するためのC#コードを定義
  $code = @"
  using System.Runtime.InteropServices;
  public class UserInputBlocker {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool BlockInput([In, MarshalAs(UnmanagedType.Bool)] bool fBlock);
  }
"@

  # 上記のC#コードをPowerShell内で利用可能にする
  Add-Type -TypeDefinition $code -Language CSharp

  try {
    # ◆ 1. ユーザー入力をブロック
    [UserInputBlocker]::BlockInput($true)

    # ◆ 2. ディスプレイの電源をオフにする (以前のコードと同じ)
    Add-Type -AssemblyName System.Windows.Forms
    $message = [System.Windows.Forms.Message]::Create([System.Windows.Forms.Form]::new().Handle, 274, 61808, 2)
    [System.Windows.Forms.NativeWindow]::new().DefWndProc([ref]$message)

    # ◆ 3. 2秒間待機（この間に発生した入力ノイズは無視される）
    # この時間を長くすると、その分だけ復帰までの時間がかかります。
    Start-Sleep -Seconds 10

  } finally {
    # ◆ 4. 処理が成功しても失敗しても、必ず入力ブロックを解除
    [UserInputBlocker]::BlockInput($false)
  }
}
