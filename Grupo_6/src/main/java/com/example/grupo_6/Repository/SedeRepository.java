package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Sede;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface SedeRepository extends JpaRepository<Sede, Integer> {

    @Query("SELECT DISTINCT s FROM Sede s " +
            "LEFT JOIN s.sedeServicios ss " +
            "LEFT JOIN ss.servicio serv " +
            "WHERE LOWER(s.nombre) LIKE LOWER(CONCAT('%', :nombre, '%')) " +
            "AND (:servicio = '' OR LOWER(serv.nombre) LIKE LOWER(CONCAT('%', :servicio, '%')))")
    Page<Sede> buscarPorNombreYServicio(@Param("nombre") String nombre,
                                        @Param("servicio") String servicio,
                                        Pageable pageable);


}
