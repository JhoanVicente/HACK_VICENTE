<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.KardexController" %>
<%@ page import="java.util.List" %>
<%@ page import="controller.ProductoController" %>
<%@ page import="model.Productos" %>
<%@ page import="service.KardexService" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Kardex" %>

<%
    // Instanciar servicios y controladores
    KardexService kardexService = new KardexService();
    ProductoController productController = new ProductoController();

    // Obtener la lista de productos
    List<Productos> productos = productController.listarTodos();

    // Obtener parámetros de búsqueda
    String productoID = request.getParameter("productoID");
    String estado = request.getParameter("estado"); // 'A' o 'I'

    Productos productoSeleccionado = null;
    List<Kardex> compras = null;

    // Lógica para filtrar según parámetros
    if (productoID != null && !productoID.isEmpty()) {
        productoSeleccionado = productController.obtenerProductoPorID(Integer.parseInt(productoID));

        if (estado != null && (estado.equals("A") || estado.equals("I"))) {
            compras = kardexService.buscarPorProductoYEstado(Integer.parseInt(productoID), estado);
        } else {
            compras = kardexService.buscarComprasPorProducto(Integer.parseInt(productoID));
        }
    } else if (estado != null && (estado.equals("A") || estado.equals("I"))) {
        compras = kardexService.buscarPorEstado(estado);
    } else {
        compras = kardexService.buscarTodosActivos();
    }

    // Formateador de fechas
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMMM-yyyy", new java.util.Locale("es", "ES"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listado de Compras</title>
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



    <div class="container mt-5">
        <h1 class="text-center mb-4">Listado de Compras</h1>

        <!-- Filtro por producto -->
        <div class="row">
            <div class="col-md-8">
                <form action="listarCompras.jsp" method="get">
                    <div class="mb-3">
                        <label for="productoID" class="form-label">Seleccionar Producto:</label>
                        <select id="productoID" name="productoID" class="form-select">
                            <option value="">Seleccione un producto</option>
                            <% for (Productos producto : productos) { %>
                            <option value="<%= producto.getProductoID() %>"
                                    <%= (productoID != null && productoID.equals(String.valueOf(producto.getProductoID()))) ? "selected" : "" %>>
                                <%= producto.getNombre() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </form>
            </div>
        </div>

        <!-- Botones para listar activos/inactivos -->
        <div class="row mt-3">
            <div class="mb-3">
                <a href="listarCompras.jsp?<%= productoID != null ? "productoID=" + productoID + "&" : "" %>estado=A"
                   class="btn btn-success">Listar Activos</a>
                <a href="listarCompras.jsp?<%= productoID != null ? "productoID=" + productoID + "&" : "" %>estado=I"
                   class="btn btn-secondary">Listar Inactivos</a>
            </div>
        </div>

        <!-- Tabla de resultados -->
        <% if (compras != null && !compras.isEmpty()) { %>
        <div class="row mt-4">
            <div class="col-12">
                <h4 class="text-center">Listado de Compras - Ventas</h4>
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>Fecha Compra</th>
                        <th>Cantidad</th>
                        <th>Precio Unitario</th>
                        <th>Monto Total</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Kardex compra : compras) {
                        String fechaCompraStr = dateFormat.format(compra.getFecha());
                        int cantidadCompra = compra.getCantidad();
                        double precioCompra = compra.getPrecioUnitario();
                        double montoCompra = cantidadCompra * precioCompra;
                    %>
                    <tr>
                        <td><%= fechaCompraStr %></td>
                        <td><%= cantidadCompra %></td>
                        <td><%= precioCompra %></td>
                        <td><%= montoCompra %></td>
                        <td>
                            <% if (compra.getEstado() == 'I') { %>
                            <!-- Botón para Reactivar -->
                            <form action="reactivarMovimiento" method="post" style="display: inline;">
                                <input type="hidden" name="kardexID" value="<%= compra.getKardexID() %>">
                                <button type="submit" class="btn btn-sm btn-success">Reactivar</button>
                            </form>
                            <% } else { %>
                            <!-- Botón para Editar -->
                            <a href="editarMovimiento?movimientoId=<%= compra.getKardexID() %>" class="btn btn-sm btn-warning">Editar</a>
                            <!-- Botón para Eliminar -->
                            <form action="eliminarMovimiento" method="post" style="display: inline;">
                                <input type="hidden" name="kardexID" value="<%= compra.getKardexID() %>">
                                <button type="submit" class="btn btn-sm btn-danger">Eliminar</button>
                            </form>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } else { %>
        <div class="row mt-4">
            <div class="col-12">
                <p class="text-center text-muted">No hay movimientos para mostrar.</p>
            </div>
        </div>
        <% } %>
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
