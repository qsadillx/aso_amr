Import-Module ActiveDirectory

$archivoCSV = Read-Host -Prompt "Introduce la ruta completa del archivo CSV"

if (-not (Test-Path $archivoCSV)) {
    Write-Host "Archivo no encontrado."
    Exit
}

$usuarios = Import-Csv -Path $archivoCSV

if ($usuarios.Count -eq 0) {
    Write-Host "El archivo CSV está vacío."
    Exit
}

$estructuraOU = @{
    "ASIR" = @{
        "Primero" = "OU=PRIMERO,OU=ASIR,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
        "Segundo" = "OU=SEGUNDO,OU=ASIR,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
    }
    "DAM" = @{
        "Primero" = "OU=PRIMERO,OU=DAM,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
        "Segundo" = "OU=SEGUNDO,OU=DAM,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
    }
    "SMR" = @{
        "Primero" = "OU=PRIMERO,OU=SMR,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
        "Segundo" = "OU=SEGUNDO,OU=SMR,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
    }
    "DAW" = @{
        "Primero" = "OU=PRIMERO,OU=DAW,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
        "Segundo" = "OU=SEGUNDO,OU=DAW,OU=ALUMNOS,OU=USUARIOS,DC=amr,DC=local"
    }
}

# ruta base para carpeta de los alumnos
$directorioBase = "C:\\Compartida\\Alumnos"

foreach ($usuario in $usuarios) {
    if ([string]::IsNullOrWhiteSpace($usuario.Nombre) -or 
        [string]::IsNullOrWhiteSpace($usuario.'Primer Apellido') -or 
        [string]::IsNullOrWhiteSpace($usuario.Ciclo) -or 
        [string]::IsNullOrWhiteSpace($usuario.Curso)) {
        Continue
    }

    $nombreUsuario = "$($usuario.Nombre)$($usuario.'Primer Apellido'[0])$($usuario.'Segundo Apellido'[0])"
    $upn = "$nombreUsuario@amr.local"
    $rutaOU = $null

    if ($estructuraOU.ContainsKey($usuario.Ciclo) -and $estructuraOU[$usuario.Ciclo].ContainsKey($usuario.Curso)) {
        $rutaOU = "OU=USUARIOS,$($estructuraOU[$usuario.Ciclo][$usuario.Curso])"
    } else {
        Write-Host "Error: Ciclo o curso no válido para el usuario $nombreUsuario"
        Continue
    }

    # creamos carpeta personal
    $rutaHome = Join-Path -Path $directorioBase -ChildPath $nombreUsuario
    
    if (-not (Test-Path $rutaHome)) {
        New-Item -ItemType Directory -Path $rutaHome -Force
        Write-Host "Carpeta personal creada para $nombreUsuario en $rutaHome"
    }

    # creamos user
    New-ADUser -Name "$($usuario.Nombre) $($usuario.'Primer Apellido') $($usuario.'Segundo Apellido')" `
        -GivenName $usuario.Nombre `
        -Surname "$($usuario.'Primer Apellido') $($usuario.'Segundo Apellido')" `
        -SamAccountName $nombreUsuario `
        -UserPrincipalName $upn `
        -Path $rutaOU `
        -AccountPassword (ConvertTo-SecureString "Villabalter1" -AsPlainText -Force) `
        -Enabled $true `
        -ScriptPath "conecta.bat" `
        -HomeDirectory $rutaHome `
        -HomeDrive "H:"

    Write-Host "Usuario $nombreUsuario creado en $rutaOU con home directory en $rutaHome"

    # configurar permisos carpeta user
    $usuarioAD = Get-ADUser -Identity $nombreUsuario
    $sidUsuario = $usuarioAD.SID
    $acl = Get-Acl $rutaHome

    # eliminamos permisos heredados
    $acl.SetAccessRuleProtection($true, $false)
    
    # agregamos permisos de control total solo a user
    $reglaUsuario = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $sidUsuario, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
    )
    $acl.SetAccessRule($reglaUsuario)

    # denegamos acceso a otros usuarios
    $grupoUsuarios = "DOMAIN USERS"
    $reglaDenegar = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $grupoUsuarios, "FullControl", "ContainerInherit,ObjectInherit", "None", "Deny"
    )
    $acl.AddAccessRule($reglaDenegar)

    Set-Acl -Path $rutaHome -AclObject $acl
    Write-Host "Permisos configurados para la carpeta de $nombreUsuario"
}

Write-Host "Proceso completado."
