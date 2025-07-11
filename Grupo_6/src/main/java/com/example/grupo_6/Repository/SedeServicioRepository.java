package com.example.grupo_6.Repository;
import com.example.grupo_6.Dto.ServicioComplejoDTO;
import com.example.grupo_6.Dto.ServicioSimplificado;
import com.example.grupo_6.Entity.Sede;
import com.example.grupo_6.Entity.Servicio;
import com.example.grupo_6.Repository.SedeServicioRepository;
import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Entity.SedeServicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SedeServicioRepository extends JpaRepository<SedeServicio, Integer> {
    List<SedeServicio> findBySedeIdsede(Integer idsede);

    List<SedeServicio> findBySede_Idsede(Integer idsede);

    Optional<SedeServicio> findBySedeAndServicio(Sede sede, Servicio servicio);


    @Query("""
    SELECT ss.idSedeServicio AS idSedeServicio,
           s.nombre AS nombre,
           s.descripcion AS descripcion,
           ss.activo AS estadoServicio,
           ss.nombrePersonalizado AS nombrePersonalizado,
           t.monto AS monto
    FROM SedeServicio ss
    JOIN ss.servicio s
    JOIN ss.tarifa t
    WHERE ss.sede.idsede = :idSede
""")
    List<ServicioPorSedeDTO> obtenerServiciosPorSede(@Param("idSede") Integer idSede);


    @Query("""
    SELECT 
        s.nombre AS nombreServicio, 
        se.nombre AS nombreSede, 
        se.direccion AS direccion, 
        s.idservicio AS idServicio
    FROM SedeServicio ss
    JOIN ss.servicio s
    JOIN ss.sede se
    WHERE s.tipoServicio.idtipo = ?1 AND s.estado.idestado = 4
""")
    List<ServicioSimplificado> listarServiciosSimplificadosPorTipo(int idtipo);


    @Query("""
        SELECT ss
        FROM SedeServicio ss
        JOIN FETCH ss.servicio s
        JOIN FETCH ss.tarifa t
        WHERE ss.idSedeServicio = :id
    """)
    Optional<SedeServicio> obtenerDetalleComplejoPorId(@Param("id") Integer id);


    @Query("""
    SELECT 
        s.idservicio AS idServicio,
        s.nombre AS nombreServicio,
        se.nombre AS nombreSede,
        se.direccion AS direccion,
        se.imagen AS imagen,               
        
        ss.idSedeServicio AS idSedeServicio,
        ss.nombrePersonalizado AS nombrePersonalizado
    FROM SedeServicio ss
    JOIN ss.servicio s
    JOIN ss.sede se
    WHERE s.tipoServicio.idtipo = :idtipo AND s.estado.idestado = 4
""")
    List<ServicioComplejoDTO> listarServiciosPorTipoConNombre(@Param("idtipo") int idtipo);
}