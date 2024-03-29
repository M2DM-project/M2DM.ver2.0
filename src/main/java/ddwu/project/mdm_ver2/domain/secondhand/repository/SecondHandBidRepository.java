package ddwu.project.mdm_ver2.domain.secondhand.repository;

import ddwu.project.mdm_ver2.domain.secondhand.entity.SecondHandBid;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SecondHandBidRepository extends JpaRepository<SecondHandBid, Long> {

    Optional<SecondHandBid> findById(Long shBidId);

    List<SecondHandBid> findAllBySecondHandId(Long shId);

    List<SecondHandBid> findAllBySecondHandIdOrderByIdDesc(Long shId);

    List<SecondHandBid> findAllBySecondHandIdOrderByPriceAsc(Long shId);

    List<SecondHandBid> findAllBySecondHandIdOrderByPriceDesc(Long shId);

    SecondHandBid saveAndFlush(SecondHandBid secondHanBid);

    Long countBySecondHandId(Long shId);

    List<SecondHandBid> findAllByBidUserId(Long userId);

    void deleteById(Long ShBidId);
}