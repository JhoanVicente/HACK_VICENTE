<%@ page import="model.Kardex" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Movimiento</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <script>
        function calcularMontoTotal() {
            const cantidad = document.getElementById("cantidad").value;
            const precioUnitario = document.getElementById("precioUnitario").value;
            const montoTotal = cantidad * precioUnitario;
            document.getElementById("montoTotal").value = montoTotal.toFixed(2); // Actualiza el monto total
        }
    </script>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Sistema Kardex</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="movimientos.jsp">Movimientos</a></li>
                <li class="nav-item"><a class="nav-link" href="ProductoList.jsp">Productos</a></li>
                <li class="nav-item"><a class="nav-link" href="registroKardex.jsp">Registro de Compras o Ventas</a></li>
                <li class="nav-item"><a class="nav-link" href="listarCompras.jsp">Listado compras</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container mt-4">
    <h1 class="text-center">Editar Movimiento</h1>
    <%
        Kardex movimiento = (Kardex) request.getAttribute("movimiento");
        String error = (String) request.getAttribute("error");
    %>
    <% if (error != null) { %>
    <div class="alert alert-danger"><%= error %></div>
    <% } %>
    <% if (movimiento != null) { %>
    <form method="post" action="editarMovimiento">
        <input type="hidden" name="kardexID" value="<%= movimiento.getKardexID() %>">
        <div class="mb-3">
            <label for="fecha" class="form-label">Fecha:</label>
            <input type="date" id="fecha" name="fecha" class="form-control" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(movimiento.getFecha()) %>" required>
        </div>
        <div class="mb-3">
            <label for="cantidad" class="form-label">Cantidad:</label>
            <input type="number" id="cantidad" name="cantidad" class="form-control" value="<%= movimiento.getCantidad() %>" required oninput="calcularMontoTotal()">
        </div>
        <div class="mb-3">
            <label for="precioUnitario" class="form-label">Precio Unitario:</label>
            <input type="number" step="0.01" id="precioUnitario" name="precioUnitario" class="form-control" value="<%= movimiento.getPrecioUnitario() %>" readonly>
        </div>
        <div class="mb-3">
            <label for="montoTotal" class="form-label">Monto Total:</label>
            <input type="number" step="0.01" id="montoTotal" name="montoTotal" class="form-control" value="<%= movimiento.getCantidad() * movimiento.getPrecioUnitario() %>" readonly>
        </div>
        <button type="submit" class="btn btn-success">Guardar Cambios</button>
        <a href="listarKardex" class="btn btn-secondary">Cancelar</a>
    </form>
    <% } else { %>
    <p class="text-center mt-4">No se encontró información para el movimiento especificado.</p>
    <% } %>

</div>
</body>
</html>
