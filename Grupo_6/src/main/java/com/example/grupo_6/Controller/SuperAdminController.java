package com.example.grupo_6.Controller;
import com.example.grupo_6.Dto.DetalleCoordinadorDTO;
import com.example.grupo_6.Entity.HorarioAtencion.DiaSemana;

import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import com.example.grupo_6.Service.FileUploadService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.*;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.exception.SdkException;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.NoSuchKeyException;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLConnection;
import java.time.*;

import java.text.Normalizer;

import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
public class SuperAdminController {

    @Autowired
    private UsuarioRepository usuarioRepository;
    private final Map<Integer, String> mapaRoles = Map.of(
            1, "Superadmin",
            2, "Administrador",
            3, "Coordinador",
            4, "Vecino"
    );
    @Autowired
    private TarifaRepository tarifaRepository;

    @Autowired
    private ServicioRepository servicioRepository;
    @Autowired
    private FileUploadService fileUploadService;
    @Autowired
    private AsistenciaCoordinadorRepository asistenciaCoordinadorRepository;
    @Autowired
    private SedeServicioRepository sedeServicioRepository;
    @Autowired
    private EstadoRepository estadoRepository;
    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private PagoRepository pagoRepository;
    @Autowired
    private SedeRepository sedeRepository;
    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;
    @Autowired
    private HorarioAtencionRepository horarioAtencionRepository;


    @Autowired
    private CoordinadorSedeRepository coordinadorSedeRepository;

    @Autowired
    private CoordinadorHorarioRepository coordinadorHorarioRepository;

    private void cargarEstadisticas(Model model, YearMonth mes, String rol) {
        if (mes == null) {
            mes = YearMonth.now();
        }

        LocalDate inicioMes = mes.atDay(1);
        LocalDate finMes = mes.atEndOfMonth();
        LocalDateTime inicioLdt = inicioMes.atStartOfDay();
        LocalDateTime finLdt = finMes.atTime(LocalTime.MAX);
        Timestamp inicioTs = Timestamp.valueOf(inicioLdt);
        Timestamp finTs = Timestamp.valueOf(finLdt);

        long reservasDelMes = reservaRepository.countByFechaCreacionBetween(inicioLdt, finLdt);
        long usuariosTotales = (rol == null || rol.isEmpty())
                ? usuarioRepository.count()
                : usuarioRepository.countUsuariosPorNombreRol(rol);
        long usuariosNuevos = usuarioRepository.countByCreateTimeBetween(inicioTs, finTs);

        model.addAttribute("reservasDelMes", reservasDelMes);
        model.addAttribute("usuariosTotales", usuariosTotales);
        model.addAttribute("usuariosNuevos", usuariosNuevos);
        model.addAttribute("mesActual", mes.toString());
        model.addAttribute("rolActual", rol);
    }




    // Vista principal del superadmin
    @GetMapping("/superadmin")
    public String superadminHome(Model model) {
        System.out.println("Entrando a controlador /superadmin");

        model.addAttribute("rol", "superadmin");
        model.addAttribute("usuariosConectados", 0); // Temporal o lo puedes quitar
        model.addAttribute("totalReservas", reservaRepository.count());
        model.addAttribute("totalSedes", sedeRepository.count());

        // Agregamos las métricas del mes actual y sin filtro de rol
        YearMonth mesActual = YearMonth.now();
        cargarEstadisticas(model, mesActual, null);

        try {
            ObjectMapper objectMapper = new ObjectMapper();

            // Reservas por día (para gráfico de línea)
            List<Map<String, Object>> reservasPorDia = reservaRepository.countReservasPorDiaFormatted();
            model.addAttribute("reservasPorDiaJson", objectMapper.writeValueAsString(reservasPorDia));

            // Usuarios por rol (para gráfico de torta)
            List<Map<String, Object>> usuariosPorRol = usuarioRepository.countUsuariosPorRolFormatted();
            model.addAttribute("usuariosPorRolJson", objectMapper.writeValueAsString(usuariosPorRol));

            // Reservas por estado (opcional)
            List<Map<String, Object>> estadoReservas = reservaRepository.countReservasPorEstado()
                    .stream()
                    .map(row -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("estado", row[0]);
                        map.put("cantidad", row[1]);
                        return map;
                    }).collect(Collectors.toList());
            model.addAttribute("estadoReservasJson", objectMapper.writeValueAsString(estadoReservas));

        } catch (JsonProcessingException e) {
            e.printStackTrace(); // También puedes redirigir a una página de error o loguear mejor
        }

        return "superadmin/superadmin_home";
    }


    // Vista de gestión de usuarios

    // En SuperAdminController.java

    @GetMapping("/perfil-superadmin")
    public String verPerfilSuperadmin(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        model.addAttribute("perfil", usuario);
        return "superadmin/superadmin_perfil";
    }

    @PostMapping("/perfil-superadmin/actualizar")
    public String actualizarPerfilSuperadmin(HttpSession session,
                                             @RequestParam String correo,
                                             @RequestParam String telefono,
                                             @RequestParam String direccion) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Usuario u = usuarioRepository.findByIdusuario(usuario.getIdusuario());
        if (u != null) {
            u.setEmail(correo);
            u.setTelefono(telefono);
            u.setDireccion(direccion);
            usuarioRepository.save(u);
            session.setAttribute("usuario", u); // actualizar en sesión
        }
        return "redirect:/perfil-superadmin?success";
    }

    @GetMapping("/superadmin/servicios")
    public String listarServicios(Model model) {
        model.addAttribute("listaServicios", servicioRepository.findAll());
        return "superadmin/superadmin_servicios";
    }

    @GetMapping("/superadmin/servicios/editar/{id}")
    public String editarServicio(@PathVariable("id") int id, Model model) {
        Servicio servicio = servicioRepository.findById(id).orElseThrow();
        model.addAttribute("servicio", servicio);
        return "superadmin/superadmin_servicios_update";
    }


    @PostMapping("/superadmin/usuarios/imagen")
    public String subirImagenUsuario(@RequestParam("idusuario") Integer idUsuario,
                                     @RequestParam("foto") MultipartFile foto,
                                     RedirectAttributes redirectAttributes) {
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        if (foto != null && !foto.isEmpty()) {
            String nombreArchivo = "usuario-" + idUsuario + getExtension(foto.getOriginalFilename());
            String key = fileUploadService.subirArchivoSobrescribible(foto, "usuarios", nombreArchivo);
            usuario.setImagen(nombreArchivo);
            usuarioRepository.save(usuario);
            redirectAttributes.addFlashAttribute("mensaje", "Foto actualizada correctamente");
        } else {
            redirectAttributes.addFlashAttribute("error", "No se seleccionó ningún archivo");
        }

        return "redirect:/superadmin/usuarios"; // ajusta a la vista correspondiente
    }

    private String getExtension(String filename) {
        return filename != null && filename.contains(".")
                ? filename.substring(filename.lastIndexOf("."))
                : "";
    }


    @GetMapping("/superadmin/usuarios")
    public String listarUsuarios(
            @RequestParam(required = false) String filtro,
            @RequestParam(required = false, defaultValue = "nombre") String campo,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("idusuario").ascending());
        Page<Usuario> paginaUsuarios;

        if (filtro != null && !filtro.trim().isEmpty()) {
            String valor = filtro.trim().toLowerCase();
            paginaUsuarios = switch (campo) {
                case "correo" -> usuarioRepository.buscarPorCorreo(valor, pageable);
                case "estado" -> usuarioRepository.buscarPorEstado(valor, pageable);
                case "rol" -> usuarioRepository.buscarPorRol(valor, pageable);
                case "id" -> usuarioRepository.buscarPorId(valor, pageable);
                default -> usuarioRepository.buscarPorNombre(valor, pageable);
            };
        } else {
            paginaUsuarios = usuarioRepository.findAll(pageable);
        }

        model.addAttribute("usuarios", paginaUsuarios.getContent());
        model.addAttribute("pagina", paginaUsuarios);
        model.addAttribute("paginaActual", page);
        model.addAttribute("totalPaginas", paginaUsuarios.getTotalPages());
        model.addAttribute("filtro", filtro);
        model.addAttribute("campo", campo);
        model.addAttribute("mapaRoles", mapaRoles);
        return "superadmin/superadmin_usuarios";
    }


    @GetMapping("/superadmin/volver")
    public String volverASuperadmin(HttpServletRequest request) {
        Usuario original = (Usuario) request.getSession().getAttribute("usuario_original");
        if (original != null) {
            request.getSession().setAttribute("usuario", original);
            request.getSession().removeAttribute("usuario_original");
        }
        return "redirect:/superadmin";
    }








    // Cambiar rol del usuario
    @PostMapping("/cambiar-rol")
    public String cambiarRol(@RequestParam Integer idusuario, @RequestParam Integer rol, HttpSession session) {
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);

        // Impedir que el superadmin se cambie a sí mismo
        if (u != null && mapaRoles.containsKey(rol)
                && !(usuarioLogueado.getIdusuario().equals(u.getIdusuario()))
                && rol != 1) {
            u.setIdrol(rol);
            usuarioRepository.save(u);
        }

        return "redirect:/superadmin/usuarios";
    }





    // Banear usuario (poner inactivo)
    @PostMapping("/superadmin/usuarios/{id}/ban")
    public String banearUsuario(@PathVariable("id") Integer idusuario, HttpSession session) {
        Integer sessionId = (Integer) session.getAttribute("idusuario");
        if (idusuario.equals(sessionId)) {
            return "redirect:/superadmin/usuarios"; // prevenir auto-baneo
        }
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);
        if (u != null) {
            u.setEstado("inactivo");
            usuarioRepository.save(u);
        }
        return "redirect:/superadmin/usuarios";
    }


    // Activar usuario
    @PostMapping("/superadmin/usuarios/{id}/activar")
    public String activarUsuario(@PathVariable("id") Integer idusuario, HttpSession session) {
        Integer sessionId = (Integer) session.getAttribute("idusuario");
        if (idusuario.equals(sessionId)) {
            return "redirect:/superadmin/usuarios"; // prevenir auto-activación forzada
        }
        Usuario usuario = usuarioRepository.findById(idusuario).orElse(null);
        if (usuario != null) {
            usuario.setEstado("activo");
            usuarioRepository.save(usuario);
        }
        return "redirect:/superadmin/usuarios";
    }


    // Eliminar usuario
    @PostMapping("/eliminar")
    public String eliminarUsuario(@RequestParam("idusuario") Integer idusuario, HttpSession session) {
        Integer sessionId = (Integer) session.getAttribute("idusuario");
        if (idusuario.equals(sessionId)) {
            return "redirect:/superadmin/usuarios"; // evitar que se borre a sí mismo
        }
        usuarioRepository.deleteById(idusuario);
        return "redirect:/superadmin/usuarios";
    }


    // Crear usuario
    @GetMapping("/superadmin/usuarios/nuevo")
    public String mostrarFormularioNuevoUsuario(Model model) {
        model.addAttribute("usuario", new Usuario()); // objeto vacío para el form
        return "superadmin/superadmin_usuarios_formulario";
    }

    @GetMapping("/superadmin/usuarios/editar/{id}")
    public String mostrarFormularioEdicion(@PathVariable("id") Integer id, Model model) {
        Usuario usuario = usuarioRepository.findById(id).orElse(null);
        if (usuario == null) return "redirect:/superadmin/usuarios";
        model.addAttribute("usuario", usuario);
        return "superadmin/superadmin_usuarios_update";
    }


    @PostMapping("/superadmin/usuarios/actualizar")
    public String actualizarUsuario(
            @ModelAttribute("usuario") Usuario usuarioForm,
            @RequestParam(value = "rawPassword", required = false) String rawPassword,
            @RequestParam(value = "foto", required = false) MultipartFile foto,
            RedirectAttributes attr) {

        // 1) Cargar existente
        Usuario existente = usuarioRepository.findById(usuarioForm.getIdusuario())
                .orElse(null);
        if (existente == null) {
            attr.addFlashAttribute("mensajeError", "Usuario no encontrado.");
            return "redirect:/superadmin/usuarios";
        }

        // 2) Validaciones (DNI, email, teléfono)
        String dni = usuarioForm.getDni();
        if (dni == null || !dni.matches("\\d{8}")) {
            attr.addFlashAttribute("mensajeError", "El DNI debe tener 8 dígitos numéricos.");
            return "redirect:/superadmin/usuarios/editar/" + usuarioForm.getIdusuario();
        }
        if (!dni.equals(existente.getDni()) && usuarioRepository.existsByDni(dni)) {
            attr.addFlashAttribute("mensajeError", "Otro usuario ya usa ese DNI.");
            return "redirect:/superadmin/usuarios/editar/" + usuarioForm.getIdusuario();
        }

        String email = usuarioForm.getEmail();
        if (!email.equals(existente.getEmail()) && usuarioRepository.existsByEmail(email)) {
            attr.addFlashAttribute("mensajeError", "Otro usuario ya usa ese correo.");
            return "redirect:/superadmin/usuarios/editar/" + usuarioForm.getIdusuario();
        }

        String telefono = usuarioForm.getTelefono();
        if (telefono == null || !telefono.matches("\\d{9}")) {
            attr.addFlashAttribute("mensajeError", "El teléfono debe tener 9 dígitos numéricos.");
            return "redirect:/superadmin/usuarios/editar/" + usuarioForm.getIdusuario();
        }

        // 3) Actualizar campos
        existente.setDni(dni);
        existente.setNombres(usuarioForm.getNombres());
        existente.setApellidos(usuarioForm.getApellidos());
        existente.setEmail(email);
        existente.setTelefono(telefono);
        existente.setDireccion(usuarioForm.getDireccion());
        existente.setIdrol(usuarioForm.getIdrol());
        existente.setNotificarRecordatorio(usuarioForm.getNotificarRecordatorio());
        existente.setNotificarDisponibilidad(usuarioForm.getNotificarDisponibilidad());

        // 4) Contraseña si se ingresó nueva
        if (rawPassword != null && !rawPassword.trim().isEmpty()) {
            existente.setPasswordHash(BCrypt.hashpw(rawPassword, BCrypt.gensalt()));
            System.out.println(" Contraseña actualizada para usuario " + existente.getIdusuario());
        } else {
            System.out.println(" Se mantiene la contraseña previa para usuario " + existente.getIdusuario());
        }

        // 5) Foto si se subió nueva
        if (foto != null && !foto.isEmpty()) {
            String ext = getExtension(foto.getOriginalFilename());
            String nombreArchivo = "usuario-" + existente.getIdusuario() + ext;
            fileUploadService.subirArchivoSobrescribible(foto, "usuarios", nombreArchivo);
            existente.setImagen(nombreArchivo);
            System.out.println("📸 Foto actualizada para usuario " + existente.getIdusuario() + ": " + nombreArchivo);
        }

        // 6) Persistir
        usuarioRepository.save(existente);
        attr.addFlashAttribute("mensajeExito", "Usuario actualizado con éxito.");
        return "redirect:/superadmin/usuarios";
    }

    @GetMapping("/superadmin/usuarios/imagen/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> verImagenUsuario(@PathVariable Integer id) {
        Usuario u = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        if (u.getImagen() == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        byte[] data = fileUploadService.descargarArchivoSobrescribible("usuarios", u.getImagen());
        String mime = fileUploadService.obtenerMimeDesdeKey(u.getImagen());
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(mime))
                .body(data);
    }


    // Manejo de errores global para debugging
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e) {
        e.printStackTrace(); // Log para consola
        return "error";       // Asegúrate de tener un error.html
    }
    @PostMapping("/superadmin/usuarios/guardar")
    public String guardarUsuario(
            @ModelAttribute Usuario usuario,
            @RequestParam("rawPassword") String rawPassword,
            @RequestParam(value = "foto", required = false) MultipartFile foto,
            RedirectAttributes attr) {

        // ——————————————————————————
        // 1) Forzar siempre INSERT (nunca update)
        usuario.setIdusuario(null);

        // 2) Validar rol y campos
        if (usuario.getIdrol() != null && usuario.getIdrol() == 1) {
            attr.addFlashAttribute("mensajeError", "No está permitido crear usuarios con rol Superadmin.");
            return "redirect:/superadmin/usuarios/nuevo";
        }

        String dni = usuario.getDni();
        if (dni == null || !dni.matches("\\d{8}")) {
            attr.addFlashAttribute("mensajeError", "El DNI debe tener exactamente 8 dígitos numéricos.");
            return "redirect:/superadmin/usuarios/nuevo";
        }
        if (usuarioRepository.existsByDni(dni)) {
            attr.addFlashAttribute("mensajeError", "Ya existe un usuario registrado con ese DNI.");
            return "redirect:/superadmin/usuarios/nuevo";
        }

        String email = usuario.getEmail();
        if (email == null || usuarioRepository.existsByEmail(email)) {
            attr.addFlashAttribute("mensajeError", "Ya existe un usuario registrado con ese correo.");
            return "redirect:/superadmin/usuarios/nuevo";
        }

        String telefono = usuario.getTelefono();
        if (telefono == null || !telefono.matches("\\d{9}")) {
            attr.addFlashAttribute("mensajeError", "El teléfono debe tener exactamente 9 dígitos numéricos.");
            return "redirect:/superadmin/usuarios/nuevo";
        }

        // ——————————————————————————
        // 3) Setear estado, timestamp y hash de la contraseña
        usuario.setEstado("activo");
        usuario.setCreateTime(new Timestamp(System.currentTimeMillis()));
        usuario.setPasswordHash(BCrypt.hashpw(rawPassword, BCrypt.gensalt()));

        // ——————————————————————————
        // 4) Guardar nuevo usuario
        Usuario saved = usuarioRepository.save(usuario);
        System.out.println("✅ Nuevo usuario INSERTADO con ID " + saved.getIdusuario());

        // ——————————————————————————
        // 5) Subir foto si viene archivo
        if (foto != null && !foto.isEmpty()) {
            String ext = getExtension(foto.getOriginalFilename());
            String nombreArchivo = "usuario-" + saved.getIdusuario() + ext;
            fileUploadService.subirArchivoSobrescribible(foto, "usuarios", nombreArchivo);
            saved.setImagen(nombreArchivo);
            usuarioRepository.save(saved);
            System.out.println("   📸 Foto subida y asociada como: " + nombreArchivo);
        }

        attr.addFlashAttribute("mensajeExito", "Usuario registrado exitosamente.");
        return "redirect:/superadmin/usuarios";
    }




    @GetMapping("/superadmin/asistencias")
    public String listarAsistencias(@RequestParam(defaultValue = "0") int page,
                                    @RequestParam(defaultValue = "coordinador") String campo,
                                    @RequestParam(required = false) String filtro,
                                    @RequestParam(required = false) String mes,
                                    Model model) {

        System.out.printf("[DEBUG] Página solicitada: %d - Campo: %s - Filtro: %s - Mes: %s%n", page, campo, filtro, mes);

        // Sanear entradas antes de usarlas
        if (filtro != null && filtro.isBlank()) filtro = null;
        if (mes != null && mes.isBlank()) mes = null;

        Pageable pageable = PageRequest.of(page, 10);
        Page<AsistenciaCoordinador> asistencias;

        boolean hayFiltro = filtro != null;
        boolean hayMes = mes != null;

        if (!hayFiltro && !hayMes) {
            System.out.println("[DEBUG] No se aplicaron filtros. Listando todos.");
            asistencias = asistenciaCoordinadorRepository.findAll(pageable);
        } else {
            asistencias = switch (campo) {
                case "sede" -> {
                    System.out.println("[DEBUG] Filtro por sede");
                    yield asistenciaCoordinadorRepository.buscarPorSedeYMes(filtro != null ? filtro : "", mes, pageable);
                }
                case "estado" -> {
                    System.out.println("[DEBUG] Filtro por estado");
                    if (filtro == null) {
                        System.out.println("[ERROR] Estado nulo");
                        yield Page.empty(pageable);
                    }
                    try {
                        var estado = AsistenciaCoordinador.EstadoAsistencia.valueOf(filtro.toLowerCase());
                        yield asistenciaCoordinadorRepository.buscarPorEstadoYMes(estado, mes, pageable);
                    } catch (IllegalArgumentException e) {
                        System.out.println("[ERROR] Estado inválido: " + filtro);
                        yield Page.empty(pageable);
                    }
                }
                case "dni" -> {
                    System.out.println("[DEBUG] Filtro por DNI");
                    yield asistenciaCoordinadorRepository.buscarPorDniYMes(filtro != null ? filtro : "", mes, pageable);
                }
                default -> {
                    System.out.println("[DEBUG] Filtro por nombre de coordinador");
                    yield asistenciaCoordinadorRepository.buscarPorNombreYMes(filtro != null ? filtro : "", mes, pageable);
                }
            };

        }

        int ultimaPagina = Math.max(0, asistencias.getTotalPages() - 1);
        System.out.printf("[DEBUG] Total páginas: %d - Última página válida: %d%n", asistencias.getTotalPages(), ultimaPagina);

        if (page > ultimaPagina) {
            System.out.println("[DEBUG] Página fuera de rango. Redireccionando...");
            return "redirect:/superadmin/asistencias?page=" + ultimaPagina +
                    "&campo=" + campo +
                    "&filtro=" + (filtro != null ? filtro : "") +
                    (mes != null ? "&mes=" + mes : "");
        }

        model.addAttribute("asistencias", asistencias.getContent());
        model.addAttribute("paginaActual", page);
        model.addAttribute("totalPaginas", asistencias.getTotalPages());
        model.addAttribute("campo", campo);
        model.addAttribute("filtro", filtro);
        model.addAttribute("mes", mes);
        return "superadmin/superadmin_asistencias";
    }




    @PostMapping("/superadmin/asistencias/estado")
    public String actualizarEstado(@RequestParam("idasistencia") Integer idasistencia,
                                   @RequestParam("estado") String estadoNuevo,
                                   RedirectAttributes attr) {
        Optional<AsistenciaCoordinador> opt = asistenciaCoordinadorRepository.findById(idasistencia);
        if (opt.isPresent()) {
            try {
                AsistenciaCoordinador ac = opt.get();
                ac.setEstado(AsistenciaCoordinador.EstadoAsistencia.valueOf(estadoNuevo));
                asistenciaCoordinadorRepository.save(ac);
                attr.addFlashAttribute("msg", "Estado actualizado correctamente");
            } catch (Exception e) {
                attr.addFlashAttribute("error", "Estado inválido");
            }
        } else {
            attr.addFlashAttribute("error", "Asistencia no encontrada");
        }
        return "redirect:/superadmin/asistencias";
    }

    @GetMapping("/superadmin/asistencias/{id}")
    public String verDetalleAsistencia(@PathVariable("id") Integer id, Model model) {
        Optional<AsistenciaCoordinador> opt = asistenciaCoordinadorRepository.findById(id);
        if (opt.isPresent()) {
            model.addAttribute("asistencia", opt.get());
            return "superadmin/detalle_asistencia";
        }
        return "redirect:/superadmin/asistencias";
    }


    @GetMapping("/superadmin/sedes")
    public String listarSedes(
            Model model,
            @RequestParam(defaultValue = "") String filtroNombre,
            @RequestParam(defaultValue = "") String filtroServicio,
            @RequestParam(defaultValue = "0") int page
    ) {
        page = Math.max(0, page);
        Pageable pageable = PageRequest.of(page, 10);
        Page<Sede> sedesFiltradas = sedeRepository.buscarPorNombreYServicio(filtroNombre, filtroServicio, pageable);

        List<String> listaServicios = servicioRepository.obtenerNombres(); // para el selector
        model.addAttribute("listaSedes", sedesFiltradas.getContent());
        model.addAttribute("totalPages", sedesFiltradas.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("filtroNombre", filtroNombre);
        model.addAttribute("filtroServicio", filtroServicio);
        model.addAttribute("listaServicios", listaServicios);
        return "superadmin/superadmin_sedes";
    }


    @PostMapping("/superadmin/sedes/desactivar/{id}")
    public String desactivarSede(@PathVariable("id") int id) {
        Optional<Sede> optSede = sedeRepository.findById(id);
        if (optSede.isPresent()) {
            Sede sede = optSede.get();
            sede.setActivo(false);
            sedeRepository.save(sede);
        }
        return "redirect:/superadmin/sedes";
    }

    @PostMapping("/superadmin/sedes/activar/{id}")
    public String activarSede(@PathVariable("id") int id) {
        Optional<Sede> optSede = sedeRepository.findById(id);
        if (optSede.isPresent()) {
            Sede sede = optSede.get();
            sede.setActivo(true);
            sedeRepository.save(sede);
        }
        return "redirect:/superadmin/sedes";
    }

    @GetMapping("/superadmin/sedes/nueva")
    public String nuevaSede(Model model) {
        model.addAttribute("sede", new Sede());
        return "superadmin/superadmin_sedes_formulario";
    }
    @GetMapping("/superadmin/sedes/ver/{id}")
    public String verSede(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isPresent()) {
            model.addAttribute("sede", optionalSede.get());
            return "superadmin/superadmin_sedes_detalle";
        } else {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }
    }

    @GetMapping("/superadmin/sedes/photo")
    public ResponseEntity<byte[]> verFotoSede(@RequestParam("nombre") String nombreArchivo) {
        // Descarga los bytes desde S3 (carpeta “sedes”)
        byte[] data;
        try {
            data = fileUploadService
                    .descargarArchivoSobrescribible("sedes", nombreArchivo);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }

        // Detecta el MIME
        String mime = URLConnection.guessContentTypeFromName(nombreArchivo);
        if (mime == null) mime = "application/octet-stream";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(mime));
        headers.setCacheControl(CacheControl.noStore());

        return new ResponseEntity<>(data, headers, HttpStatus.OK);
    }


    @GetMapping("/superadmin/coordinadores")
    public String vistaDashboardCoordinadores(
            @RequestParam(required = false) String mes,
            @RequestParam(required = false) Integer id,
            @RequestParam(required = false) String filtro,
            Model model) {

        if (mes == null || mes.isBlank()) {
            mes = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }

        List<DetalleCoordinadorDTO> coordinadores = asistenciaCoordinadorRepository.obtenerResumenCoordinadoresPorMes(mes);
        List<Map<String, Object>> coordinadoresConPct = new ArrayList<>();
        Map<String, Object> coordinadorSeleccionado = null;

        for (DetalleCoordinadorDTO dto : coordinadores) {
            long total = dto.getPresente() + dto.getTarde() + dto.getFalta();
            double puntualidadPct = total > 0 ? (dto.getPresente() * 100.0) / total : 0;
            double tardanzaPct = total > 0 ? (dto.getTarde() * 100.0) / total : 0;
            double faltaPct = total > 0 ? (dto.getFalta() * 100.0) / total : 0;

            Map<String, Object> mapa = new HashMap<>();
            mapa.put("idusuario", dto.getIdusuario());
            mapa.put("nombres", dto.getNombres());
            mapa.put("apellidos", dto.getApellidos());
            mapa.put("dni", dto.getDni());
            mapa.put("presente", dto.getPresente());
            mapa.put("tarde", dto.getTarde());
            mapa.put("falta", dto.getFalta());
            mapa.put("puntualidadPct", Math.round(puntualidadPct));
            mapa.put("tardanzaPct", Math.round(tardanzaPct));
            mapa.put("faltasPct", Math.round(faltaPct));
            mapa.put("incidencias", dto.getIncidencias());

            coordinadoresConPct.add(mapa);

            boolean coincideId = (id != null && Objects.equals(dto.getIdusuario(), id));
            boolean coincideDni = (filtro != null && filtro.equals(dto.getDni()));

            if (coincideId || coincideDni) {
                coordinadorSeleccionado = mapa;
            }
        }

        List<Usuario> todosCoordinadores = usuarioRepository.findByRolNombre("COORDINADOR");
        model.addAttribute("todosCoordinadores", todosCoordinadores);
        model.addAttribute("coordinador", coordinadorSeleccionado);
        model.addAttribute("mes", mes);
        model.addAttribute("id", id);
        model.addAttribute("filtro", filtro);

        return "superadmin/superadmin_coordinadores";
    }




    @PostMapping("/superadmin/sedes/actualizar")
    public String actualizarSede(
            @ModelAttribute("sede") Sede sede,
            @RequestParam(value = "foto", required = false) MultipartFile foto,
            RedirectAttributes attr) {

        // Si subieron foto, la guardamos en S3 bajo "sedes/<idsede>.<ext>"
        if (foto != null && !foto.isEmpty()) {
            // Asegurarnos de limpiar el nombre original
            String original = StringUtils.cleanPath(foto.getOriginalFilename());
            String ext = "";
            int dot = original.lastIndexOf('.');
            if (dot >= 0) {
                ext = original.substring(dot + 1);
            }
            // Usamos el ID de la sede para el nombre (evita colisiones)
            String nombreArchivo = sede.getIdsede()
                    + (ext.isEmpty() ? "" : "." + ext);

            // Sube (o reemplaza) en S3: key = "sedes/" + nombreArchivo
            fileUploadService.subirArchivoSobrescribible(foto, "sedes", nombreArchivo);

            // Guardamos sólo el nombre del archivo en la entidad
            sede.setImagen(nombreArchivo);
        }

        // Guardar la sede (con o sin nueva foto)
        sedeRepository.save(sede);
        attr.addFlashAttribute("mensajeExito", "Sede actualizada correctamente.");
        return "redirect:/superadmin/sedes";
    }




    @GetMapping("/superadmin/sedes/configurar/{id}")
    public String configurarSede(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {

        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isEmpty()) {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }

        Sede sede = optionalSede.get();
        model.addAttribute("sede", sede);
        model.addAttribute("listaServicios", servicioRepository.findAll());
        model.addAttribute("listaTarifas", tarifaRepository.findAll());
        model.addAttribute("dias", List.of("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"));

        // Cargar o generar los 7 días
        List<HorarioAtencion> horarios = new ArrayList<>();
        for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
            Optional<HorarioAtencion> ha = horarioAtencionRepository.findBySedeAndDiaSemana(sede, dia);
            horarios.add(ha.orElse(new HorarioAtencion(null, sede, dia, null, null, false)));
        }
        model.addAttribute("listaHorariosAtencion", horarios);

        model.addAttribute("horariosDisponibles", horarioDisponibleRepository.findByHorarioAtencion_Sede_Idsede(id));

        return "superadmin/superadmin_sedes_configurar";
    }



    @PostMapping("/superadmin/sedes/configurar/servicios")
    public String asignarServicio(@RequestParam("idsede") Integer idsede,
                                  @RequestParam("idservicio") Integer idservicio,
                                  @RequestParam("idtarifa") Integer idtarifa,
                                  @RequestParam("nombrePersonalizado") String nombrePersonalizado,
                                  RedirectAttributes attr) {

        Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
        Optional<Servicio> servOpt = servicioRepository.findById(idservicio);
        Optional<Tarifa> tarifaOpt = tarifaRepository.findById(idtarifa);

        if (sedeOpt.isPresent() && servOpt.isPresent() && tarifaOpt.isPresent()) {
            Sede sede = sedeOpt.get();
            Servicio servicio = servOpt.get();
            Tarifa tarifa = tarifaOpt.get();

            SedeServicio ss = new SedeServicio();
            ss.setSede(sede);
            ss.setServicio(servicio);
            ss.setTarifa(tarifa);
            ss.setNombrePersonalizado(nombrePersonalizado);
            ss.setActivo(true);
            sedeServicioRepository.save(ss); // Necesario para obtener el ID de sede_servicio

            // Obtener horarios de atención activos para la sede
            List<HorarioAtencion> horarios = horarioAtencionRepository.findBySedeAndActivoTrue(sede);
            for (HorarioAtencion ha : horarios) {
                // Ajuste especial si el fin es 00:00 (lo consideramos como 23:59)
                LocalTime horaFinComparada = ha.getHoraFin().equals(LocalTime.MIDNIGHT)
                        ? LocalTime.of(23, 59)
                        : ha.getHoraFin();

                for (int h = 0; h < 24; h++) {
                    LocalTime inicio = LocalTime.of(h, 0);
                    LocalTime fin = (h == 23) ? LocalTime.of(23, 59) : inicio.plusHours(1);

                    boolean yaExiste = horarioDisponibleRepository
                            .existsByHorarioAtencionAndHoraInicioAndHoraFinAndServicio(ha, inicio, fin, servicio);

                    if (!yaExiste) {
                        HorarioDisponible nuevo = new HorarioDisponible();
                        nuevo.setHorarioAtencion(ha);
                        nuevo.setServicio(servicio);
                        nuevo.setHoraInicio(inicio);
                        nuevo.setHoraFin(fin);
                        nuevo.setAforoMaximo(30);

                        // Solo activo si está dentro del rango definido por el horario de atención
                        boolean estaDentroDelRango = ha.isActivo() &&
                                !inicio.isBefore(ha.getHoraInicio()) &&
                                !fin.isAfter(horaFinComparada);
                        nuevo.setActivo(estaDentroDelRango);

                        horarioDisponibleRepository.save(nuevo);
                    }
                }
            }

            attr.addFlashAttribute("mensajeExito", "Servicio asignado y horarios generados automáticamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "Error al asignar servicio.");
        }

        return "redirect:/superadmin/sedes/configurar/" + idsede;
    }
    @PostMapping("/superadmin/sedes/configurar/servicios/actualizar-foto")
    public String actualizarFotoServicio(
            @RequestParam("idsedeServicio") Integer idsedeServicio,
            @RequestParam("foto") MultipartFile foto,
            RedirectAttributes attr) {

        Optional<SedeServicio> opt = sedeServicioRepository.findById(idsedeServicio);
        if (opt.isPresent() && foto != null && !foto.isEmpty()) {
            SedeServicio ss = opt.get();

            // Derivar extensión y nombre constante para poder sobreescribir
            String original = StringUtils.cleanPath(foto.getOriginalFilename());
            String ext = "";
            int dot = original.lastIndexOf('.');
            if (dot >= 0) ext = original.substring(dot + 1);

            String nombreArchivo = idsedeServicio + (ext.isEmpty() ? "" : "." + ext);

            // Subida sobrescribible en S3
            fileUploadService.subirArchivoSobrescribible(foto, "servicio-sede", nombreArchivo);

            // Guardar en BD sólo el nombre del archivo
            ss.setImagen(nombreArchivo);
            sedeServicioRepository.save(ss);

            attr.addFlashAttribute("mensajeExito", "Foto actualizada correctamente.");
            return "redirect:/superadmin/sedes/configurar/" + ss.getSede().getIdsede();
        }

        attr.addFlashAttribute("mensajeError", "No se pudo actualizar la foto.");
        return "redirect:/superadmin/sedes/configurar/" + idsedeServicio;
    }

    /**
     * GET: Sirve la foto de un servicio‐sede desde S3
     */
    @GetMapping("/superadmin/sedes/configurar/servicios/photo")
    public ResponseEntity<byte[]> verFotoServicio(
            @RequestParam("idsedeServicio") Integer idsedeServicio) {

        Optional<SedeServicio> opt = sedeServicioRepository.findById(idsedeServicio);
        if (opt.isEmpty() || opt.get().getImagen() == null) {
            return ResponseEntity.notFound().build();
        }

        String nombreArchivo = opt.get().getImagen();
        byte[] data = fileUploadService
                .descargarArchivoSobrescribible("servicio-sede", nombreArchivo);

        String mime = URLConnection.guessContentTypeFromName(nombreArchivo);
        if (mime == null) mime = "application/octet-stream";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(mime));
        headers.setCacheControl(CacheControl.noStore());

        return new ResponseEntity<>(data, headers, HttpStatus.OK);
    }

    @PostMapping("/superadmin/sedes/configurar/intervalos/toggle")
    public String toggleEstadoHorario(@RequestParam("idhorario") Integer idhorario,
                                      RedirectAttributes attr) {
        Optional<HorarioDisponible> opt = horarioDisponibleRepository.findById(idhorario);
        if (opt.isPresent()) {
            HorarioDisponible hd = opt.get();
            hd.setActivo(!hd.getActivo());
            horarioDisponibleRepository.save(hd);
            Integer idSede = hd.getHorarioAtencion().getSede().getIdsede();
            attr.addFlashAttribute("mensajeExito", "Estado del horario actualizado.");
            return "redirect:/superadmin/sedes/configurar/" + idSede;
        }
        attr.addFlashAttribute("mensajeError", "Horario no encontrado.");
        return "redirect:/superadmin/sedes";
    }

    @GetMapping("/superadmin/sedes/asignar-coordinadores/{idsede}")
    public String vistaAsignarCoordinadores(
            @PathVariable Integer idsede,
            Model model) {

        Sede sede = sedeRepository.findById(idsede).orElseThrow();
        List<Usuario> coordinadores    = usuarioRepository.obtenerCoordinadoresActivos();
        List<CoordinadorSede> asignas   = coordinadorSedeRepository.findBySede_Idsede(idsede);
        List<Integer> activosIds        = asignas.stream()
                .filter(CoordinadorSede::isActivo)
                .map(cs -> cs.getUsuario().getIdusuario())
                .toList();
        List<CoordinadorSede> asignados = asignas.stream()
                .filter(CoordinadorSede::isActivo)
                .toList();

        // lista de horas 00:00–23:00
        List<String> horas = IntStream.rangeClosed(0,23)
                .mapToObj(i -> String.format("%02d:00", i))
                .toList();

        // grilla de atención de sede
        List<HorarioAtencion> horariosAtencion =
                horarioAtencionRepository.findBySede_IdsedeOrderByDiaSemanaAsc(idsede);

        // **Nuevo**: map <idusuario → <DiaSemana → turno>>
        Map<Integer, Map<HorarioAtencion.DiaSemana, CoordinadorHorario>> turnosPorCoord = new HashMap<>();
        for (CoordinadorSede cs : asignados) {
            List<CoordinadorHorario> turnos =
                        coordinadorHorarioRepository.findAllByCoordinadorSede(cs);
            Map<HorarioAtencion.DiaSemana, CoordinadorHorario> porDia = turnos.stream()
                    .collect(Collectors.toMap(
                            CoordinadorHorario::getDiaSemana,
                            Function.identity()
                    ));
            turnosPorCoord.put(cs.getUsuario().getIdusuario(), porDia);
        }

        model.addAttribute("sede", sede);
        model.addAttribute("coordinadores", coordinadores);
        model.addAttribute("coordinadoresActivos", activosIds);
        model.addAttribute("coordinadoresAsignados", asignados);
        model.addAttribute("horas", horas);
        model.addAttribute("horariosAtencion", horariosAtencion);
        model.addAttribute("turnosPorCoord", turnosPorCoord);

        return "superadmin/superadmin_asignar_coordinadores";
    }


    @PostMapping("/superadmin/sedes/asignar-coordinadores")
    public String asignarCoordinadores(
            @RequestParam Integer idsede,
            @RequestParam("coordinadores") List<Integer> idsUsuarios,
            @RequestParam Map<String, String> allParams) {

        // 1) Desactivar todas las asignaciones previas
        List<CoordinadorSede> actuales =
                coordinadorSedeRepository.findBySede_Idsede(idsede);
        actuales.forEach(cs -> cs.setActivo(false));
        coordinadorSedeRepository.saveAll(actuales);

        // 2) Reactivar o crear nuevas asignaciones
        for (Integer uid : idsUsuarios) {
            CoordinadorSede cs = coordinadorSedeRepository
                    .findByUsuario_IdusuarioAndSede_Idsede(uid, idsede)
                    .orElseGet(() -> {
                        CoordinadorSede nuevo = new CoordinadorSede();
                        nuevo.setUsuario(usuarioRepository.findById(uid).orElseThrow());
                        nuevo.setSede(sedeRepository.findById(idsede).orElseThrow());
                        return nuevo;
                    });
            cs.setActivo(true);
            coordinadorSedeRepository.save(cs);

            // 3) Para cada día de la semana, configurar el turno
            String prefix = "turnos[" + uid + "]";
            for (HorarioAtencion ha : horarioAtencionRepository.findBySede_IdsedeOrderByDiaSemanaAsc(idsede)) {
                DiaSemana dia = ha.getDiaSemana();            // ya es un enum
                String base   = "turnos[" + uid + "][" + dia.name() + "]";

                String he = allParams.get(base + ".horaEntrada");
                String hs = allParams.get(base + ".horaSalida");
                boolean activo = allParams.containsKey(base + ".activo");

                // desactivar previos
                coordinadorHorarioRepository
                        .findByCoordinadorSedeAndDiaSemana(cs, dia)
                        .ifPresent(ch -> ch.setActivo(false));

// crear o actualizar
                CoordinadorHorario ch = coordinadorHorarioRepository
                        .findByCoordinadorSedeAndDiaSemana(cs, dia)
                        .orElse(new CoordinadorHorario(cs, dia));  // ahora el constructor recibe el enum

                ch.setHoraEntrada(LocalTime.parse(he));
                ch.setHoraSalida(LocalTime.parse(hs));
                ch.setActivo(activo);
                coordinadorHorarioRepository.save(ch);

            }
        }

        return "redirect:/superadmin/sedes/asignar-coordinadores/" + idsede;
    }

    @PostMapping("/superadmin/sedes/coordinadores/desasignar")
    public String desasignarCoordinador(
            @RequestParam("idCoordinadorSede") Integer id,
            @RequestParam("idsede") Integer idsede) {

        CoordinadorSede cs = coordinadorSedeRepository.findById(id).orElseThrow();
        cs.setActivo(false);
        coordinadorSedeRepository.save(cs);

        return "redirect:/superadmin/sedes/asignar-coordinadores/" + idsede;
    }






    @PostMapping("/superadmin/sedes/configurar/servicios/toggle-estado")
    public String toggleEstado(@RequestParam("idsedeServicio") Integer idsedeServicio,
                               RedirectAttributes attr) {
        Optional<SedeServicio> opt = sedeServicioRepository.findById(idsedeServicio);

        if (opt.isPresent()) {
            SedeServicio ss = opt.get();
            ss.setActivo(!ss.isActivo());
            sedeServicioRepository.save(ss);
            attr.addFlashAttribute("mensajeExito", "Estado del servicio actualizado.");
        } else {
            attr.addFlashAttribute("mensajeError", "Servicio no encontrado.");
        }

        return "redirect:/superadmin/sedes/configurar/" + opt.get().getSede().getIdsede();
    }

    @PostMapping("/superadmin/sedes/configurar/servicios/actualizar-tarifa")
    public String actualizarTarifaYNombre(@RequestParam("idsedeServicio") Integer idss,
                                          @RequestParam("idtarifa") Integer idtarifa,
                                          @RequestParam("nombrePersonalizado") String nombrePersonalizado,
                                          RedirectAttributes attr) {
        Optional<SedeServicio> ssOpt = sedeServicioRepository.findById(idss);
        Optional<Tarifa> tarifaOpt = tarifaRepository.findById(idtarifa);

        if (ssOpt.isPresent() && tarifaOpt.isPresent()) {
            SedeServicio ss = ssOpt.get();
            ss.setTarifa(tarifaOpt.get());
            ss.setNombrePersonalizado(nombrePersonalizado.trim());
            sedeServicioRepository.save(ss);

            attr.addFlashAttribute("mensajeExito", "Nombre y tarifa actualizados.");
        } else {
            attr.addFlashAttribute("mensajeError", "Error al actualizar datos.");
        }

        return "redirect:/superadmin/sedes/configurar/" + ssOpt.get().getSede().getIdsede();
    }








    @PostMapping("/superadmin/sedes/configurar/atencion/guardar")
    public String guardarHorariosAtencion(@RequestParam("idsede") Integer idsede,
                                          HttpServletRequest request,
                                          RedirectAttributes attr) {
        Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
        if (sedeOpt.isEmpty()) {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }

        Sede sede = sedeOpt.get();

        for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
            String nombreDia = dia.name(); // Ej. "LUNES"

            String inicioParam = request.getParameter("horaInicio_" + nombreDia);
            String finParam = request.getParameter("horaFin_" + nombreDia);
            boolean activo = request.getParameter("activo_" + nombreDia) != null;

            LocalTime horaInicio = null;
            LocalTime horaFin = null;

            if (inicioParam != null && !inicioParam.isEmpty()) {
                horaInicio = LocalTime.parse(inicioParam);
            }
            if (finParam != null && !finParam.isEmpty()) {
                horaFin = LocalTime.parse(finParam);
            }

            // Buscar o crear el horario para ese día
            HorarioAtencion horario = horarioAtencionRepository.findBySedeAndDiaSemana(sede, dia)
                    .orElse(new HorarioAtencion(null, sede, dia, null, null, false));

            horario.setHoraInicio(horaInicio);
            horario.setHoraFin(horaFin);
            horario.setActivo(activo);

            horarioAtencionRepository.save(horario);
        }
        List<SedeServicio> sedeServicios = sedeServicioRepository.findBySede_Idsede(idsede);
        List<HorarioDisponible> horariosDisponibles = horarioDisponibleRepository.findByHorarioAtencion_Sede_Idsede(idsede);

        for (HorarioDisponible hd : horariosDisponibles) {
            LocalTime hi = hd.getHoraInicio();
            LocalTime hf = hd.getHoraFin();
            HorarioAtencion ha = hd.getHorarioAtencion();

            boolean activo = ha.isActivo() &&
                    ha.getHoraInicio() != null &&
                    ha.getHoraFin() != null &&
                    !hi.isBefore(ha.getHoraInicio()) &&
                    !hf.isAfter(ha.getHoraFin());

            hd.setActivo(activo);
            horarioDisponibleRepository.save(hd);
        }


        attr.addFlashAttribute("mensajeExito", "Horarios de atención actualizados.");
        return "redirect:/superadmin/sedes/configurar/" + idsede;
    }



    @PostMapping("/superadmin/sedes/configurar/intervalos")
    public String agregarHorarioDisponible(@RequestParam("idhorarioAtencion") Integer idHorarioAtencion,
                                           @RequestParam("idservicio") Integer idservicio,
                                           @RequestParam("horaInicio") String horaInicio,
                                           @RequestParam("horaFin") String horaFin,
                                           RedirectAttributes attr) {

        Optional<HorarioAtencion> haOpt = horarioAtencionRepository.findById(idHorarioAtencion);
        Optional<Servicio> servOpt = servicioRepository.findById(idservicio);

        if (haOpt.isPresent() && servOpt.isPresent()) {
            HorarioDisponible intervalo = new HorarioDisponible();
            intervalo.setHorarioAtencion(haOpt.get());
            intervalo.setServicio(servOpt.get());
            intervalo.setHoraInicio(LocalTime.parse(horaInicio));
            intervalo.setHoraFin(LocalTime.parse(horaFin));
            intervalo.setActivo(true);

            horarioDisponibleRepository.save(intervalo);
            attr.addFlashAttribute("mensajeExito", "Intervalo agregado correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "No se encontró el horario o servicio asociado.");
        }

        return "redirect:/superadmin/sedes/configurar/" + haOpt.map(h -> h.getSede().getIdsede()).orElse(-1);
    }






    @GetMapping("/superadmin/sedes/editar/{id}")
    public String mostrarFormularioEdicion(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isPresent()) {
            model.addAttribute("sede", optionalSede.get());
            return "superadmin/superadmin_sedes_update"; // ¡nombre corregido!
        } else {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }
    }





    @PostMapping("/superadmin/sedes/guardar")
    public String guardarSede(
            @ModelAttribute("sede") Sede sede,
            @RequestParam("foto") MultipartFile foto,
            RedirectAttributes attr) {

        // Establece el distrito fijo
        sede.setDistrito("San Miguel");

        // Si subieron una foto, la subimos sobrescribible y guardamos solo el nombre
        if (foto != null && !foto.isEmpty()) {
            String nombreArchivo = foto.getOriginalFilename();
            // esto crea o reemplaza sedes/nombreArchivo en S3
            fileUploadService.subirArchivoSobrescribible(foto, "sedes", nombreArchivo);
            // en la BD solo guardamos el nombre, para luego descargar con descargarArchivoSobrescribible
            sede.setImagen(nombreArchivo);
        }

        // Guardamos la sede (ya incluye imagen si se subió)
        sedeRepository.save(sede);

        // Creamos los horarios si aún no existen
        if (sede.getIdsede() != null && horarioAtencionRepository.countBySede(sede) == 0) {
            for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
                HorarioAtencion ha = new HorarioAtencion();
                ha.setSede(sede);
                ha.setDiaSemana(dia);
                if (dia == HorarioAtencion.DiaSemana.Domingo) {
                    ha.setHoraInicio(LocalTime.of(0, 0));
                    ha.setHoraFin(LocalTime.of(0, 0));
                    ha.setActivo(false);
                } else {
                    ha.setHoraInicio(LocalTime.of(8, 0));
                    ha.setHoraFin(LocalTime.of(20, 0));
                    ha.setActivo(true);
                }
                horarioAtencionRepository.save(ha);
            }
        }

        attr.addFlashAttribute("mensajeExito", "Sede guardada correctamente.");
        return "redirect:/superadmin/sedes";
    }






    @GetMapping("/superadmin/reservas")
    public String listarReservas(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String campo,
            @RequestParam(required = false) String filtro,
            @RequestParam(required = false) Integer idReservaDestacado,
            Model model
    ) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("idreserva").ascending());




        Page<Reserva> paginaReservas;

        if (campo != null && filtro != null && !filtro.trim().isEmpty()) {
            switch (campo) {
                case "nombre" -> paginaReservas = reservaRepository.filtrarPorNombre(filtro, pageable);
                case "dni" -> paginaReservas = reservaRepository.filtrarPorDni(filtro, pageable);
                case "codigo" -> {
                    try {
                        Integer id = Integer.parseInt(filtro.trim());
                        paginaReservas = reservaRepository.buscarPorIdExacto(id, pageable);
                    } catch (NumberFormatException e) {
                        paginaReservas = Page.empty(pageable); // evita error si ingresan letras
                    }
                }
                case "fecha" -> {
                    LocalDate fechaParseada = null;
                    try {
                        fechaParseada = LocalDate.parse(filtro);
                    } catch (DateTimeParseException ignored) {}
                    paginaReservas = reservaRepository.filtrarPorFecha2(fechaParseada, pageable);
                }
                case "estado" -> paginaReservas = reservaRepository.filtrarPorEstado2(filtro, pageable);
                default -> paginaReservas = reservaRepository.findAll(pageable);
            }
        } else {
            paginaReservas = reservaRepository.findAll(pageable);
        }

        model.addAttribute("reservas", paginaReservas.getContent());
        model.addAttribute("paginaActual", page);
        model.addAttribute("totalPaginas", paginaReservas.getTotalPages());
        model.addAttribute("campo", campo);              // 🔍 necesario para que el selector muestre bien
        model.addAttribute("filtro", filtro);            // 🔍 necesario para mantener el input
        model.addAttribute("idReservaDestacado", idReservaDestacado);

        return "superadmin/superadmin_reservas";
    }








    @GetMapping("/superadmin/reservas/nueva")
    public String nuevaReserva(Model model) {
        model.addAttribute("reserva", new Reserva());

        // Filtrar sedes activas
        List<Sede> sedesActivas = sedeRepository.findAll()
                .stream()
                .filter(s -> Boolean.TRUE.equals(s.getActivo()))
                .collect(Collectors.toList());
        model.addAttribute("listaSedes", sedesActivas);

        List<HorarioDisponible> listaHorarios = horarioDisponibleRepository.findByActivoTrue();
        model.addAttribute("listaHorarios", listaHorarios);

        return "superadmin/superadmin_reservas_formulario";
    }




    @PostMapping("/superadmin/reservas/guardar")
    public String guardarReserva(@RequestParam("dni") String dni,
                                 @RequestParam("idsedeServicio") Integer idsedeServicio,
                                 @RequestParam("idhorario") Integer idhorario,
                                 @ModelAttribute("reserva") Reserva reserva,
                                 RedirectAttributes redirectAttributes) {

        Usuario usuario = usuarioRepository.findByDni(dni);
        if (usuario == null) {
            redirectAttributes.addFlashAttribute("mensajeError", "El DNI ingresado no corresponde a ningún usuario registrado.");
            return "redirect:/superadmin/reservas/nueva";
        }

        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
        Estado estadoAprobadaReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
        Estado estadoPagado = estadoRepository.findByNombreAndTipoAplicacion("pagado", Estado.TipoAplicacion.pago);

        SedeServicio sedeServicio = sedeServicioRepository.findById(idsedeServicio).orElse(null);
        if (sedeServicio == null) {
            redirectAttributes.addFlashAttribute("mensajeError", "No se encontró el servicio seleccionado.");
            return "redirect:/superadmin/reservas/nueva";
        }

        reserva.setSedeServicio(sedeServicio);

        HorarioDisponible horario = horarioDisponibleRepository.findById(idhorario).orElse(null);
        if (horario == null || !horario.getActivo()) {
            redirectAttributes.addFlashAttribute("mensajeError", "El horario seleccionado no es válido o está inactivo.");
            return "redirect:/superadmin/reservas/nueva";
        }

        reserva.setHorarioDisponible(horario);

        if (!horario.getServicio().equals(sedeServicio.getServicio())) {
            redirectAttributes.addFlashAttribute("mensajeError", "El horario seleccionado no pertenece al servicio escogido.");
            return "redirect:/superadmin/reservas/nueva";
        }

        LocalDate fecha = reserva.getFechaReserva();
        if (fecha == null || fecha.isBefore(LocalDate.now())) {
            redirectAttributes.addFlashAttribute("mensajeError", "La fecha de reserva no puede ser pasada.");
            return "redirect:/superadmin/reservas/nueva";
        }

        // Validar día del horario
        DayOfWeek dayOfWeek = fecha.getDayOfWeek();
        HorarioAtencion.DiaSemana diaReserva = switch (dayOfWeek) {
            case MONDAY    -> HorarioAtencion.DiaSemana.Lunes;
            case TUESDAY   -> HorarioAtencion.DiaSemana.Martes;
            case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
            case THURSDAY  -> HorarioAtencion.DiaSemana.Jueves;
            case FRIDAY    -> HorarioAtencion.DiaSemana.Viernes;
            case SATURDAY  -> HorarioAtencion.DiaSemana.Sábado;
            case SUNDAY    -> HorarioAtencion.DiaSemana.Domingo;
        };

        if (!horario.getHorarioAtencion().getDiaSemana().equals(diaReserva)) {
            redirectAttributes.addFlashAttribute("mensajeError", "El horario no corresponde al día seleccionado.");
            return "redirect:/superadmin/reservas/nueva";
        }

        boolean diaPermitido = horarioAtencionRepository.existsBySedeAndDiaSemanaAndActivoTrue(sedeServicio.getSede(), diaReserva);
        if (!diaPermitido) {
            redirectAttributes.addFlashAttribute("mensajeError", "No se permiten reservas el día seleccionado.");
            return "redirect:/superadmin/reservas/nueva";
        }

        // Validar aforo actual para fecha
        long aforoActual = reservaRepository.countByHorarioDisponibleAndEstadoAndFechaReserva(horario, estadoAprobadaReserva, fecha);
        if (aforoActual >= horario.getAforoMaximo()) {
            redirectAttributes.addFlashAttribute("mensajeError", "No hay cupos disponibles para este horario.");
            return "redirect:/superadmin/reservas/nueva";
        }

        // Validar si el usuario ya tiene una reserva en ese horario y fecha
        Estado estadoRechazada = estadoRepository.findByNombreAndTipoAplicacion("rechazada", Estado.TipoAplicacion.reserva);
        boolean yaTieneReservaActiva = reservaRepository.existsByUsuarioAndHorarioDisponibleAndFechaReservaAndEstadoNot(
                usuario, horario, fecha, estadoRechazada
        );
        if (yaTieneReservaActiva) {
            redirectAttributes.addFlashAttribute("mensajeError", "Ya tienes una reserva activa para ese horario en esa fecha.");
            return "redirect:/superadmin/reservas/nueva";
        }



        // Crear y guardar pago + reserva
        Pago pago = new Pago();
        pago.setUsuario(usuario);
        pago.setMetodo(Pago.Metodo.banco);
        pago.setMonto(BigDecimal.valueOf(sedeServicio.getTarifa().getMonto()));
        pago.setEstado(estadoPendientePago);
        pago.setFechaPago(null);
        pagoRepository.save(pago);

        reserva.setUsuario(usuario);
        reserva.setFechaCreacion(LocalDateTime.now());
        reserva.setFechaLimitePago(reserva.getFechaCreacion().plusHours(4));
        reserva.setPago(pago);
        reserva.setEstado(pago.getEstado().equals(estadoPagado) ? estadoAprobadaReserva : estadoPendienteReserva);

        reservaRepository.save(reserva);
        redirectAttributes.addFlashAttribute("mensajeExito", "Reserva y pago creados correctamente.");
        return "redirect:/superadmin/reservas";
    }





    @GetMapping("/api/sede-servicios")
    public List<SedeServicio> listarServiciosPorSedePorParam(@RequestParam("sedeId") Integer sedeId) {
        return sedeServicioRepository.findBySedeIdsede(sedeId);
    }


    //@GetMapping("/api/servicios-por-sede/{idsede}")
    //  @ResponseBody
    // public List<ServicioPorSedeDTO> listarServiciosDTOporSede(@PathVariable Integer idsede) {
    // return sedeServicioRepository.obtenerServiciosPorSede(idsede);
    // }







    @GetMapping("/superadmin/reservas/ver/{id}")
    public String verReserva(@PathVariable("id") Integer id, Model model) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        model.addAttribute("reserva", reserva);
        return "superadmin/superadmin_reservas_detalle";
    }

    @PostMapping("/superadmin/reservas/aprobar-pago/{id}")
    public String aprobarPago(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);

        if (reserva != null && reserva.getPago() != null) {
            Estado aprobadoReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
            Estado confirmadoPago = estadoRepository.findByNombreAndTipoAplicacion("confirmado", Estado.TipoAplicacion.pago);

            if (aprobadoReserva != null && confirmadoPago != null) {
                reserva.setEstado(aprobadoReserva);
                reservaRepository.save(reserva);

                Pago pago = reserva.getPago();
                pago.setEstado(confirmadoPago);
                pago.setFechaPago(LocalDateTime.now());
                pagoRepository.save(pago);

                redirectAttributes.addFlashAttribute("mensajeExito", "Pago aprobado exitosamente.");
            } else {
                redirectAttributes.addFlashAttribute("mensajeError", "Estados no encontrados.");
            }
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "Reserva sin pago asociado.");
        }

        return "redirect:/superadmin/reservas";
    }








    @GetMapping("/superadmin/tarifas")
    public String listarTarifas(
            @RequestParam(defaultValue = "") String filtroNombre,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model
    ) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("descripcion").ascending());
        Page<Tarifa> paginaTarifas = tarifaRepository.findByDescripcionContainingIgnoreCase(filtroNombre, pageable);

        model.addAttribute("listaTarifas", paginaTarifas.getContent());
        model.addAttribute("filtroNombre", filtroNombre);
        model.addAttribute("paginaActual", page);
        model.addAttribute("totalPaginas", paginaTarifas.getTotalPages());
        return "superadmin/superadmin_tarifas";
    }


    @GetMapping("/superadmin/tarifas/nueva")
    public String nuevaTarifa(Model model) {
        model.addAttribute("tarifa", new Tarifa());
        return "superadmin/superadmin_tarifas_formulario";
    }

    // Guardar nueva tarifa
    @PostMapping("/superadmin/tarifas/guardar")
    public String guardarTarifa(@ModelAttribute Tarifa tarifa) {
        tarifa.setFechaActualizacion(LocalDate.now());
        tarifaRepository.save(tarifa);
        return "redirect:/superadmin/tarifas";
    }

    // Mostrar formulario para editar tarifa
    @GetMapping("/superadmin/tarifas/editar/{id}")
    public String editarTarifa(@PathVariable("id") Integer id, Model model) {
        Tarifa tarifa = tarifaRepository.findById(id).orElse(null);
        if (tarifa != null) {
            model.addAttribute("tarifa", tarifa);
            return "superadmin/superadmin_tarifas_update";
        } else {
            return "redirect:/superadmin/tarifas";
        }
    }

    // Guardar cambios en tarifa existente
    @PostMapping("/superadmin/tarifas/actualizar")
    public String actualizarTarifa(@ModelAttribute Tarifa tarifa) {
        tarifa.setFechaActualizacion(LocalDate.now());
        tarifaRepository.save(tarifa);
        return "redirect:/superadmin/tarifas";
    }
    @GetMapping("/superadmin/tarifas/eliminar/{id}")
    public String eliminarTarifa(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        if (tarifaRepository.existsById(id)) {
            tarifaRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("mensajeExito", "Tarifa eliminada correctamente.");
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "La tarifa no existe.");
        }
        return "redirect:/superadmin/tarifas";
    }
    @Autowired
    private RolRepository rolRepository;



    @GetMapping("/superadmin/estadisticas")
    public String verEstadisticas(@RequestParam(value = "mes", required = false) @DateTimeFormat(pattern = "yyyy-MM") YearMonth mes,
                                  @RequestParam(value = "rol", required = false) String rol,
                                  Model model) {
        cargarEstadisticas(model, mes, rol);
        return "superadmin/superadmin_estadisticas";
    }








    @GetMapping("/superadmin/sistema")
    public String configuracionSistema() {
        return "superadmin/superadmin_sistema";
    }

    @GetMapping("/superadmin/registros")
    public String verRegistros() {
        return "superadmin/superadmin_registros";
    }

    public int calcularPaginaDePago(Integer idPago, int size) {
        long posicion = pagoRepository.contarAntesDeId(idPago); // debes implementarlo
        return (int) (posicion / size);
    }
    @GetMapping("/superadmin/pagos/redirigir")
    public String redirigirAPago(@RequestParam("idPago") Integer idPago) {
        int size = 10; // debe coincidir con la paginación en tu vista
        int page = calcularPaginaDePago(idPago, size);
        return "redirect:/superadmin/pagos?page=" + page + "&idPagoDestacado=" + idPago;
    }

    @GetMapping("superadmin/pago/{id}/comprobante")
    @ResponseBody
    public ResponseEntity<byte[]> verComprobante(@PathVariable Integer id) {
        Optional<Pago> opt = pagoRepository.findById(id);

        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Pago pago = opt.get();
        String keyS3 = pago.getComprobante();

        if (keyS3 == null || keyS3.isBlank()) {
            return ResponseEntity.noContent().build();
        }

        try {
            byte[] archivo = fileUploadService.descargarArchivo(keyS3);
            String mimeType = fileUploadService.obtenerMimeDesdeKey(keyS3);

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(mimeType))
                    .body(archivo);
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }





    @GetMapping("/superadmin/reservas/redirigir")
    public String redirigirAReserva(@RequestParam("idReserva") Integer idReserva) {
        int size = 10;
        long posicion = reservaRepository.contarAntesDeId(idReserva);
        int page = (int) (posicion / size);

        return "redirect:/superadmin/reservas?page=" + page + "&idReservaDestacado=" + idReserva;
    }


    @GetMapping("/superadmin/pagos")
    public String listarPagos(
            Model model,
            @RequestParam(defaultValue = "") String filtroNombre,
            @RequestParam(defaultValue = "") String filtroDni,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(value = "idPagoDestacado", required = false) Integer idPagoDestacado
    ) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").ascending());
        Page<Pago> pagosFiltrados = pagoRepository.buscarPagosFiltrados(filtroNombre, filtroDni, pageable);

        model.addAttribute("listaPagos", pagosFiltrados.getContent());
        model.addAttribute("totalPages", pagosFiltrados.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("filtroNombre", filtroNombre);
        model.addAttribute("filtroDni", filtroDni);
        model.addAttribute("idPagoDestacado", idPagoDestacado);

        return "superadmin/superadmin_pagos";
    }









    @PostMapping("/superadmin/pagos/aprobar/{id}")
    public String aprobarPagoDesdePagos(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/superadmin/pagos";

        Estado estadoConfirmado = estadoRepository.findByNombreAndTipoAplicacion("confirmado", Estado.TipoAplicacion.pago);
        Estado estadoAprobadoReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
        if (estadoConfirmado == null || estadoAprobadoReserva == null) return "redirect:/superadmin/pagos";

        pago.setEstado(estadoConfirmado);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoAprobadoReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/superadmin/pagos";
    }

    @PostMapping("/superadmin/pagos/rechazar/{id}")
    public String rechazarPago(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/superadmin/pagos";

        Estado estadoRechazadoPago = estadoRepository.findByNombreAndTipoAplicacion("rechazado", Estado.TipoAplicacion.pago);
        Estado estadoRechazadoReserva = estadoRepository.findByNombreAndTipoAplicacion("rechazada", Estado.TipoAplicacion.reserva);
        if (estadoRechazadoPago == null || estadoRechazadoReserva == null) return "redirect:/superadmin/pagos";

        // Actualizar el estado del pago
        pago.setEstado(estadoRechazadoPago);
        pagoRepository.save(pago);

        // Actualizar el estado de la reserva vinculada
        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoRechazadoReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/superadmin/pagos";
    }












}
