package ddwu.project.mdm_ver2.domain.secondhand.repository;

import ddwu.project.mdm_ver2.domain.secondhand.entity.SecondHand;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SecondHandRepository extends JpaRepository<SecondHand, Long> {

    /* 최신순 (최신순) */
    List<SecondHand> findAllByOrderByIdDesc();

    /* 가격 낮은 순 */
    List<SecondHand> findAllByOrderByPriceAsc();

    /* 가격 높은 순*/
    List<SecondHand> findAllByOrderByPriceDesc();

    /* 카테고리 해당 상품 정렬(기본) */
    List<SecondHand> findAllByCategoryCateCode(String cateCode);

    /* 카테고리 해당 상품 정렬 (최신순) */
    List<SecondHand> findAllByCategoryCateCodeOrderByIdDesc(String cateCode);

    /* 카테고리 내 상품 정렬 (낮은순) */
    List<SecondHand> findAllByCategoryCateCodeOrderByPriceAsc(String cateCode);

    /* 카테고리 내 상품 정렬 (높은순) */
    List<SecondHand> findAllByCategoryCateCodeOrderByPriceDesc(String cateCode);

    /* 상품 이름 검색 */
    List<SecondHand> findByNameContainingIgnoreCase(String shName);

    Optional <SecondHand> findById(Long shId);

    SecondHand saveAndFlush(SecondHand secondHand);

    void deleteById(Long shId);

    /* 요청 수 (가격 제안 댓글 수) */

}
