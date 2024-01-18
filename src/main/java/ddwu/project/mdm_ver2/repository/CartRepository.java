package ddwu.project.mdm_ver2.repository;

import ddwu.project.mdm_ver2.domain.Cart;
import ddwu.project.mdm_ver2.domain.User;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


public interface CartRepository extends JpaRepository<Cart, Long> {

    Cart findByUser_UserCode(long userCode);

    //    Optional<Cart> findByUser(User user);

//    Optional<Cart> findByUser_UserCode(long userCode);


//    @Query("SELECT c.qty FROM Cart c WHERE c.id = :id")
//    Integer findQtyById(@Param("id") Long id);

    @Query("DELETE FROM CartItem c WHERE c.id = :id")
    @Modifying
    @Transactional
    void deleteItemsInCart(@Param("id") Long id);
}
