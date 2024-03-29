package ddwu.project.mdm_ver2.domain.order.service;

import ddwu.project.mdm_ver2.domain.cart.entity.Cart;
import ddwu.project.mdm_ver2.domain.cartItem.entity.Items;
import ddwu.project.mdm_ver2.domain.cartItem.repository.ItemsRepository;
import ddwu.project.mdm_ver2.domain.grouppurchase.entity.GroupPurchase;
import ddwu.project.mdm_ver2.domain.grouppurchase.repository.GroupPurchaseRepository;
import ddwu.project.mdm_ver2.domain.order.dto.OrderAddrRequest;
import ddwu.project.mdm_ver2.domain.order.dto.OrderCartRequest;
import ddwu.project.mdm_ver2.domain.order.dto.OrderDto;
import ddwu.project.mdm_ver2.domain.order.entity.Order;
import ddwu.project.mdm_ver2.domain.order.repository.OrderRepository;
import ddwu.project.mdm_ver2.domain.product.entity.Product;
import ddwu.project.mdm_ver2.domain.product.repository.ProductRepository;
import ddwu.project.mdm_ver2.global.exception.CustomResponse;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.webjars.NotFoundException;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@Transactional
public class OrderService {

    private final OrderRepository orderRepository;
    private final ItemsRepository itemsRepository;
    private final GroupPurchaseRepository groupPurchaseRepository;
    private final ProductRepository productRepository;

    public CustomResponse<Void> updateOrder(long orderId, OrderAddrRequest updatedOrder) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);

        if (optionalOrder.isPresent()) {
            Order existingOrder = optionalOrder.get();
            existingOrder.setZipcode(updatedOrder.getZipcode());
            existingOrder.setStreetAddr(updatedOrder.getStreetAddr());
            existingOrder.setDetailAddr(updatedOrder.getDetailAddr());

            orderRepository.save(existingOrder);
            return CustomResponse.onSuccess("주문이 수정되었습니다.");
        } else {
            return CustomResponse.onFailure(HttpStatus.NOT_FOUND.value(), "주문을 찾을 수 없습니다.");
        }
    }

    public CustomResponse<Void> cancelOrder(long orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        GroupPurchase groupPurchase = order.getGroupPurchase();

        if (groupPurchase != null) {
            int qtyToRemove = order.getQty();
            int currentQty = groupPurchase.getNowQty();
            groupPurchase.setNowQty(currentQty - qtyToRemove);
            groupPurchaseRepository.save(groupPurchase);
        }

        orderRepository.deleteById(orderId);
        return CustomResponse.onSuccess("주문이 취소되었습니다.");
    }

    public CustomResponse<Order> getOrderDetail(long orderId) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);
        return optionalOrder.map(order -> CustomResponse.onSuccess(order))
                .orElseGet(() -> CustomResponse.onFailure(HttpStatus.NOT_FOUND.value(), "주문을 찾을 수 없습니다."));
    }

    public CustomResponse<List<Order>> getOrderByUser(String email) {
        List<Order> orders = orderRepository.findByEmail(email);
        if (!orders.isEmpty()) {
            return CustomResponse.onSuccess(orders);
        } else {
            return CustomResponse.onFailure(HttpStatus.NOT_FOUND.value(), "주문을 찾을 수 없습니다.");
        }
    }

    public void updateOrderDto(Order order, OrderDto orderDto) {
        if (orderDto != null) {
            order.setName(orderDto.getName());
            order.setContact(orderDto.getContact());
            order.setZipcode(orderDto.getZipcode());
            order.setStreetAddr(orderDto.getStreetAddr());
            order.setDetailAddr(orderDto.getDetailAddr());
        }
    }

    public CustomResponse<Void> purchaseItemsFromCart(String userEmail, OrderCartRequest cartRequest) {
        Order order = new Order();
        int totalPrice = 0;
        int totalQty = 0;
        List<Long> itemIds = cartRequest.getItemIds();

        for (Long itemId : itemIds) {
            Items item = itemsRepository.findById(itemId)
                    .orElseThrow(() -> new NotFoundException("Item not found with ID: " + itemId));

            Cart cart = item.getCart();
            cart.getCartItems().remove(item);
            cart.setPrice(cart.getPrice() - item.getPrice());
            cart.setCount(cart.getCount() - item.getCount());

            item.setCart(null);
            item.setOrder(order);
            order.getCartItems().add(item);
            totalPrice += item.getPrice();
            totalQty += item.getCount();
        }

        order.setPrice(totalPrice);
        order.setQty(totalQty);
        order.setEmail(userEmail);

        OrderDto orderDto = cartRequest.getOrderDto();
        updateOrderDto(order, orderDto);

        orderRepository.save(order);

        return CustomResponse.onSuccess("장바구니 상품 주문이 승인되었습니다.");
    }

    public CustomResponse<Void> purchaseItems(String userEmail, Long productId, int purchasedQty, OrderDto orderDto) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new NotFoundException("Product not found with ID: " + productId));

        Order order = new Order();
        order.setEmail(userEmail);
        order.setProduct(product);
        order.setPrice(product.getPrice() * purchasedQty);
        order.setQty(purchasedQty);

        updateOrderDto(order, orderDto);

        orderRepository.save(order);

        return CustomResponse.onSuccess("일반 상품 주문이 승인되었습니다.");
    }
}