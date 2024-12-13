<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - Memin S.A.</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
    <style>
        body {
            display: flex;
            min-height: 100vh;
            margin: 0;
        }

        #dashboard {
            width: 250px;
            background-color: #004d40;
            color: white;
            padding: 15px;
        }

        #dashboard a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px 15px;
            border-radius: 5px;
            margin: 5px 0;
        }

        #dashboard a:hover {
            background-color: #00796b;
        }

        .content {
            flex-grow: 1;
            padding: 20px;
        }

        @media (max-width: 768px) {
            #dashboard {
                position: absolute;
                left: -250px;
                transition: left 0.3s;
            }

            #dashboard.active {
                left: 0;
            }

            #menu-toggle {
                display: block;
                margin: 10px;
                cursor: pointer;
            }
        }

        #menu-toggle {
            display: none;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<div id="dashboard">
    <h3>Sistema Kardex</h3>
    <a href="index.jsp">Inicio</a>
    <a href="movimientos.jsp">Movimientos</a>
    <a href="ProductoList.jsp">Productos</a>
    <a href="registroKardex.jsp">Registro de Compras o Ventas</a>
    <a href="listarCompras.jsp">Listado Compras</a>
</div>
<!-- Main Content -->
<div class="content">
    <div id="menu-toggle" onclick="toggleMenu()">
        <span class="navbar-toggler-icon"></span>
    </div>

</div>

<script>
    function toggleMenu() {
        const dashboard = document.getElementById('dashboard');
        dashboard.classList.toggle('active');
    }
</script>
</body>
</html>