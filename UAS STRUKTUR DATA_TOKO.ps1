# File untuk menyimpan data
$dataFile = "data_toko.csv"

# Cek apakah file data ada, jika tidak ada, buat dengan header
if (-not (Test-Path $dataFile)) {
    "ID,Name,Price" | Out-File -FilePath $dataFile
}

# Fungsi untuk menampilkan menu
function Show-Menu {
    param (
        [string]$userType
    )

    Clear-Host
    Write-Host "=== Menu Toko ==="
    Write-Host "1. Read Data"
    Write-Host "2. Create Data"
    Write-Host "3. Update Data"
    Write-Host "4. Delete Data"
    Write-Host "5. Exit"

    if ($userType -eq "admin") {
        Write-Host "6. Manage Users"
    }
}

# Fungsi untuk membaca data
function Read-Data {
    Import-Csv -Path $dataFile | Format-Table -AutoSize
}

# Fungsi untuk menambahkan data
function Create-Data {
    $id = Read-Host "Enter ID"
    $name = Read-Host "Enter Name"
    $price = Read-Host "Enter Price"

    $newItem = "$id,$name,$price"
    $newItem | Out-File -FilePath $dataFile -Append
    Write-Host "Data added successfully."
}

# Fungsi untuk memperbarui data
function Update-Data {
    $id = Read-Host "Enter ID of the item to update"
    $items = Import-Csv -Path $dataFile
    $itemToUpdate = $items | Where-Object { $_.ID -eq $id }

    if ($itemToUpdate) {
        $newName = Read-Host "Enter new Name"
        $newPrice = Read-Host "Enter new Price"

        $updatedItems = $items | ForEach-Object {
            if ($_.ID -eq $id) {
                [PSCustomObject]@{
                    ID = $id
                    Name = $newName
                    Price = $newPrice
                }
            } else {
                $_
            }
        }

        $updatedItems | Export-Csv -Path $dataFile -NoTypeInformation
        Write-Host "Data updated successfully."
    } else {
        Write-Host "Item not found."
    }
}

# Fungsi untuk menghapus data
function Delete-Data {
    $id = Read-Host "Enter ID of the item to delete"
    $items = Import-Csv -Path $dataFile
    $itemsToKeep = $items | Where-Object { $_.ID -ne $id }

    if ($items.Count -ne $itemsToKeep.Count) {
        $itemsToKeep | Export-Csv -Path $dataFile -NoTypeInformation
        Write-Host "Data deleted successfully."
    } else {
        Write-Host "Item not found."
    }
}

# Fungsi untuk mengelola pengguna (admin only)
function Manage-Users {
    Write-Host "User management is not implemented in this example."
}

# Menu utama
do {
    $userType = Read-Host "Enter your role (admin/user)"
    if ($userType -eq "admin" -or $userType -eq "user") {
        do {
            Show-Menu -userType $userType
            $choice = Read-Host "Choose an option"

            switch ($choice) {
                1 { Read-Data }
                2 { Create-Data }
                3 { Update-Data }
                4 { Delete-Data }
                5 { Write-Host "Exiting..."; break }
                6 { if ($userType -eq "admin") { Manage-Users } else { Write-Host "Invalid option." } }
                default { Write-Host "Invalid choice, please try again." }
            }
        } while ($choice -ne 5)
    } else {
        Write-Host "Invalid role, please try again."
    }
} while ($userType -ne "admin" -and $userType -ne "user")
