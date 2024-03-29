package ddwu.project.mdm_ver2.domain.order.repository;

import ddwu.project.mdm_ver2.domain.grouppurchase.entity.GroupPurchase;
import ddwu.project.mdm_ver2.domain.order.entity.Order;
import ddwu.project.mdm_ver2.domain.product.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByEmail(String email);

    List<Order> findByEmailAndGroupPurchaseIsNotNull(String email);

    boolean existsByEmailAndGroupPurchase(String email, GroupPurchase groupPurchase);

    boolean existsByEmailAndProduct(String email, Product product);

    int countByGroupPurchase_Id(Long gpId);
}