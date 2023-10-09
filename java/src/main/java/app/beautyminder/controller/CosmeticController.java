package app.beautyminder.controller;

import app.beautyminder.domain.Cosmetic;
import app.beautyminder.domain.Review;
import app.beautyminder.domain.User;
import app.beautyminder.service.ReviewService;
import app.beautyminder.service.auth.UserService;
import app.beautyminder.service.cosmetic.CosmeticService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.NoSuchElementException;

@RequiredArgsConstructor
@RestController
@RequestMapping("/cosmetic") // /review/api
public class CosmeticController {

    private final UserService userService;
    private final ReviewService reviewService;
    private final CosmeticService cosmeticService;

    private static final Logger logger = LoggerFactory.getLogger(CosmeticController.class);

    @GetMapping
    public ResponseEntity<List<Cosmetic>> getAllCosmetics() {
        List<Cosmetic> cosmetics = cosmeticService.getAllCosmetics();
        return ResponseEntity.ok(cosmetics);
    }

    // Retrieve a specific cosmetic by its ID
    @GetMapping("/{id}")
    public ResponseEntity<Cosmetic> getCosmeticById(@PathVariable String id) {
        Cosmetic cosmetic = cosmeticService.getCosmeticById(id);
        if (cosmetic == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(cosmetic);
    }

    // Add a new cosmetic
    @PostMapping
    public ResponseEntity<Cosmetic> createCosmetic(@RequestBody Cosmetic cosmetic) {
        Cosmetic newCosmetic = cosmeticService.saveCosmetic(cosmetic);
        return ResponseEntity.ok(newCosmetic);
    }

    // Update an existing cosmetic
    @PutMapping("/{id}")
    public ResponseEntity<Cosmetic> updateCosmetic(@PathVariable String id, @RequestBody Cosmetic cosmeticDetails) {
        Cosmetic updatedCosmetic = cosmeticService.updateCosmetic(id, cosmeticDetails);
        if (updatedCosmetic == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updatedCosmetic);
    }

    // Delete a cosmetic
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCosmetic(@PathVariable String id) {
        boolean deleted = cosmeticService.deleteCosmetic(id);
        if (!deleted) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().build();
    }

    // Retrieve all reviews of a specific cosmetic
    @GetMapping("/reviews/{id}")
    public ResponseEntity<List<Review>> getReviewsForCosmetic(@PathVariable String id) {
        Cosmetic cosmetic = cosmeticService.getCosmeticById(id);
        if (cosmetic == null) {
            return ResponseEntity.notFound().build();
        }
        List<Review> reviews = reviewService.getAllReviewsByCosmetic(cosmetic);
        return ResponseEntity.ok(reviews);
    }

    @PostMapping("/{userId}/favorites/{cosmeticId}")
    public ResponseEntity<User> addToUserFavorite(@PathVariable String userId, @PathVariable String cosmeticId) {
        try {
            User updatedUser = userService.addCosmeticById(userId, cosmeticId);
            return new ResponseEntity<>(updatedUser, HttpStatus.OK);
        } catch (NoSuchElementException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/{userId}/favorites/{cosmeticId}")
    public ResponseEntity<User> removeFromUserFavorite(@PathVariable String userId, @PathVariable String cosmeticId) {
        try {
            User updatedUser = userService.removeCosmeticById(userId, cosmeticId);
            return new ResponseEntity<>(updatedUser, HttpStatus.OK);
        } catch (NoSuchElementException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

//    @GetMapping("/search")
//    public ResponseEntity<SearchResponse> search(
//            @RequestParam(required = false) String name,
//            @RequestParam(required = false) String category,
//            @RequestParam(required = false) List<String> keywords) {
//
//        try {
//            SearchResponse response = rankingService.searchCosmetics(name, category, keywords);
//            return new ResponseEntity<>(response, HttpStatus.OK);
//        } catch (RuntimeException e) {
//            // Log exception and return error response
//            // (Logging mechanism/log library code should be here)
//            logger.error(e.getMessage());
//            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }
}
