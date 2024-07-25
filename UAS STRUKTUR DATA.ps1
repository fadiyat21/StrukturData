# File untuk menyimpan data produk
$DataFile = "produk.csv"

# Fungsi untuk memeriksa apakah file data ada
function Initialize-Data {
    if (-Not (Test-Path $DataFile)) {
        @"
Nama,Kategori,Harga
"@ | Out-File -FilePath $DataFile
    }
}

# Fungsi untuk membaca data
function Read-Data {
    Import-Csv -Path $DataFile
}

# Fungsi untuk menambahkan data
function Create-Data {
    $nama = Read-Host "Masukkan nama produk"
    $kategori = Read-Host "Masukkan kategori produk"
    

    $produk = [PSCustomObject]@{
        Nama     = $nama
        Kategori = $kategori
        Harga    = $harga
    }

    $produk | Export-Csv -Path $DataFile -Append -NoTypeInformation
    Write-Host "Produk berhasil ditambahkan!"
}

# Fungsi untuk memperbarui data
function Update-Data {
    $produk = Read-Data
    $nama = Read-Host "Masukkan nama produk yang ingin diperbarui"
    $produkLama = $produk | Where-Object { $_.Nama -eq $nama }

    if ($produkLama) {
        $kategori = Read-Host "Masukkan kategori baru"
        $harga = Read-Host "Masukkan harga baru"

        $produkLama.Kategori = $kategori
        $produkLama.Harga = $harga

        $produk | Export-Csv -Path $DataFile -NoTypeInformation
        Write-Host "Produk berhasil diperbarui!"
    } else {
        Write-Host "Produk tidak ditemukan!"
    }
}

# Fungsi untuk menghapus data
function Delete-Data {
    $produk = Read-Data
    $nama = Read-Host "Masukkan nama produk yang ingin dihapus"
    $produk = $produk | Where-Object { $_.Nama -ne $nama }

    if ($produk) {
        $produk | Export-Csv -Path $DataFile -NoTypeInformation
        Write-Host "Produk berhasil dihapus!"
    } else {
        Write-Host "Produk tidak ditemukan!"
    }
}

# Menu untuk admin dan user
function Show-Menu {
    param (
        [string]$UserRole
    )

    if ($UserRole -eq "admin") {
        do {
            Write-Host "=== Menu Admin ==="
            Write-Host "1. Tambah Produk"
            Write-Host "2. Perbarui Produk"
            Write-Host "3. Hapus Produk"
            Write-Host "4. Tampilkan Produk"
            Write-Host "5. Keluar"
            $choice = Read-Host "Pilih opsi (1-5)"

            switch ($choice) {
                1 { Create-Data }
                2 { Update-Data }
                3 { Delete-Data }
                4 { Read-Data | Format-Table -AutoSize }
                5 { exit }
                default { Write-Host "Opsi tidak valid!" }
            }
        } while ($choice -ne 5)
    } elseif ($UserRole -eq "user") {
        do {
            Write-Host "=== Menu User ==="
            Write-Host "1. Tampilkan Produk"
            Write-Host "2. Keluar"
            $choice = Read-Host "Pilih opsi (1-2)"

            switch ($choice) {
                1 { Read-Data | Format-Table -AutoSize }
                2 { exit }
                default { Write-Host "Opsi tidak valid!" }
            }
        } while ($choice -ne 2)
    } else {
        Write-Host "Peran tidak valid!"
    }
}

# Mulai program
Initialize-Data
$role = Read-Host "Masukkan peran Anda (admin/user)"
Show-Menu -UserRole $role
