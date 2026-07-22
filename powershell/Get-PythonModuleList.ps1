# 指定パッケージ配下の .py ファイルからドット区切りのモジュール名を一覧生成する。
# PyInstaller の hiddenimports などに貼り付けられる形式で出力する。

# 除外するファイル名。増やしたいときはこの配列に追記する。
$excludeNames = @(
    "__init__.py"
)

$packageDir = Split-Path $PSScriptRoot -Parent
$srcDir = Split-Path $packageDir -Parent

Get-ChildItem $packageDir -Recurse -Filter *.py |
Where-Object {
    $_.Name -notin $excludeNames -and
    $_.FullName -notlike "$PSScriptRoot\*"
} |
ForEach-Object {
    $relativePath = $_.FullName.Substring($srcDir.Length + 1)

    $module = $relativePath `
        -replace "\\", "." `
        -replace "\.py$", ""

    "    `"$module`","
}
