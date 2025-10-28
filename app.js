// ======================================
// Load Header & Footer + Navigation
// ======================================
async function loadPartials() {
  // Header
  const header = document.getElementById('header');
  if (header) {
    try {
      const res = await fetch('header.html');
      header.innerHTML = await res.text();
      lucide.createIcons();

      // Attach nav listeners AFTER header is loaded
      setupNavigation();
      setupMobileMenu();

    } catch (err) {
      console.error('Header load error:', err);
    }
  }

  // Footer
  const footer = document.getElementById('footer');
  if (footer) {
    try {
      const res = await fetch('footer.html');
      footer.innerHTML = await res.text();
      lucide.createIcons();
    } catch (err) {
      console.error('Footer load error:', err);
    }
  }
}

// ======================================
// Navigation Setup
// ======================================
function setupNavigation() {
    // Global delegated navigation
    document.addEventListener('click', e => {
        // Header, mobile nav buttons, and logo
        const btn = e.target.closest('.nav-btn, .mobile-nav-btn, .logo-btn');
        if (btn) {
            e.preventDefault();

            // Explicitly handle "Shop Now" button going to gallery
            const page = btn.classList.contains('shop-now-btn') 
                ? 'gallery' 
                : btn.dataset.page || 'home';
            navigateTo(page);

            // Close mobile menu if needed
            if (btn.classList.contains('mobile-nav-btn')) toggleMobileMenu();
        }

        // Footer buttons
        const footerBtn = e.target.closest('.footer-link');
        if (footerBtn) {
            e.preventDefault();
            navigateTo(footerBtn.dataset.page);
        }
    });
}

// Delegated newsletter submit handler (works even when footer is injected later)
document.addEventListener('submit', e => {
  // if the submit came from the newsletter form (or a child of it)
  const form = e.target && e.target.id === 'newsletter-form' ? e.target : null;
  if (!form) return;

  e.preventDefault(); // stop default navigation

  const message = document.getElementById('subscribe-message');
  if (message) message.style.display = 'block';

  // Optionally save email to localStorage
  try {
    const emailInput = form.querySelector('#newsletter-email');
    if (emailInput && emailInput.value) {
      const subs = JSON.parse(localStorage.getItem('newsletter-subs') || '[]');
      subs.push({ email: emailInput.value, date: new Date().toISOString() });
      localStorage.setItem('newsletter-subs', JSON.stringify(subs));
    }
  } catch (err) {
    console.warn('Could not save subscription:', err);
  }

  form.reset();
});

// ======================================
// Mobile Menu Toggle
// ======================================
function setupMobileMenu() {
  const mobileNav = document.getElementById('mobileNav');
  const menuIcon = document.querySelector('.menu-icon');
  const closeIcon = document.querySelector('.close-icon');

  window.toggleMobileMenu = function () {
    if (!mobileNav || !menuIcon || !closeIcon) return;
    mobileNav.classList.toggle("hidden");
    menuIcon.classList.toggle("hidden");
    closeIcon.classList.toggle("hidden");
  };
}

// ======================================
// SPA Navigation
// ======================================
function navigateTo(pageId) {
  const pages = document.querySelectorAll('.page');
  pages.forEach(p => p.classList.remove('active'));
  
  const target = document.getElementById(`${pageId}-page`);
  if (target) {
    target.classList.add('active');

    // Always scroll to top
    window.scrollTo({ top: 0, behavior: 'smooth' });

    // Page Titles
    const titles = {
      home: "ABC Fitness Studio - Home",
      gallery: "ABC Fitness Studio - Gallery",
      about: "ABC Fitness Studio - About Us",
      custom: "ABC Fitness Studio - Community"
    };
    document.title = titles[pageId] || "ABC Fitness Studio";
  } else {
    console.warn(`Page not found: ${pageId}-page`);
  }
}

// Initialize the home page
function initializePage() {
  const hash = window.location.hash.slice(1);
  const initialPage = hash || 'home'; 
  navigateTo(initialPage);
}

// ======================================
// Shopping Cart
// ======================================
let cart = [];

function saveCart() {
  try {
    localStorage.setItem("cart", JSON.stringify(cart));
  } catch (e) {
    console.warn('Could not save cart to localStorage:', e);
  }
}

function loadCart() {
  try {
    const saved = localStorage.getItem("cart");
    if (saved) cart = JSON.parse(saved);
  } catch (e) {
    console.warn('Could not load cart from localStorage:', e);
    cart = [];
  }
}

function toggleCart() {
  const modal = document.getElementById("cart-modal");
  if (modal) {
    modal.classList.toggle("hidden");
    updateCartUI();
  }
}

function addToCart(product) {
  const existing = cart.find((item) => item.id === product.id);
  if (existing) existing.quantity++;
  else cart.push({ ...product, quantity: 1 });

  saveCart();
  showToast(`${product.name} added to cart`);
  updateCartUI();
}

function removeFromCart(id) {
  cart = cart.filter((item) => item.id !== id);
  saveCart();
  updateCartUI();
}

function clearCart() {
  cart = [];
  hideClearDialog();
  saveCart();
  updateCartUI();
}

function updateCartUI() {
  const badge = document.getElementById("cart-badge");
  const modalItems = document.getElementById("cart-items");
  const totalEl = document.getElementById("total-amount");
  const totalContainer = document.getElementById("cart-total");
  const clearBtn = document.getElementById("clear-cart-btn");
  const processBtn = document.getElementById("process-order-btn");

  const totalItems = cart.reduce((sum, i) => sum + i.quantity, 0);
  if (badge) {
    if (totalItems > 0) {
      badge.textContent = totalItems;
      badge.classList.remove("hidden");
    } else badge.classList.add("hidden");
  }

  if (!modalItems) return;
  if (cart.length === 0) {
    modalItems.innerHTML = '<p class="empty-cart">Your cart is empty</p>';
    totalContainer?.classList.add("hidden");
    if (clearBtn) clearBtn.disabled = true;
    if (processBtn) processBtn.disabled = true;
  } else {
    modalItems.innerHTML = cart
      .map(
        (item) => `
        <div class="cart-item">
          <span>${item.name}</span>
          <div class="quantity-controls">
            <button onclick="decreaseQuantity('${item.id}')" class="btn-quantity">-</button>
            <span class="item-quantity">${item.quantity}</span>
            <button onclick="increaseQuantity('${item.id}')" class="btn-quantity">+</button>
          </div>
          <span>$${(item.price * item.quantity).toFixed(2)}</span>
          <button class="btn-danger btn-sm" onclick="removeFromCart('${item.id}')">Remove</button>
        </div>`
      )
      .join("");

    const total = cart.reduce((sum, i) => sum + i.price * i.quantity, 0);
    if (totalEl) totalEl.textContent = `$${total.toFixed(2)}`;
    totalContainer?.classList.remove("hidden");
    if (clearBtn) clearBtn.disabled = false;
    if (processBtn) processBtn.disabled = false;
  }
}

function increaseQuantity(id) {
  const item = cart.find((i) => i.id === id);
  if (item) item.quantity++;
  saveCart();
  updateCartUI();
}

function decreaseQuantity(id) {
  const item = cart.find((i) => i.id === id);
  if (item) {
    item.quantity--;
    if (item.quantity <= 0) removeFromCart(id);
  }
  saveCart();
  updateCartUI();
}

function processOrder() {
  if (cart.length === 0) return;
  hideCart();
  showOrderDialog();
  cart = [];
  saveCart();
  updateCartUI();
}

function hideCart() {
  const modal = document.getElementById("cart-modal");
  if (modal) modal.classList.add("hidden");
}

// ======================================
// Dialogs
// ======================================
function showClearDialog() {
  document.getElementById("clear-dialog")?.classList.remove("hidden");
}
function hideClearDialog() {
  document.getElementById("clear-dialog")?.classList.add("hidden");
}
function showOrderDialog() {
  document.getElementById("order-dialog")?.classList.remove("hidden");
}
function hideOrderDialog() {
  document.getElementById("order-dialog")?.classList.add("hidden");
}
function showFormSuccessDialog() {
  document.getElementById("form-success-dialog")?.classList.remove("hidden");
}
function hideFormSuccessDialog() {
  document.getElementById("form-success-dialog")?.classList.add("hidden");
}

// ======================================
// Toast Notification
// ======================================
let toastTimeout;
function showToast(message, duration = 2500) {
  const toast = document.getElementById("toast");
  if (!toast) return;
  toast.textContent = message;
  toast.classList.remove("hidden");
  clearTimeout(toastTimeout);
  toastTimeout = setTimeout(() => toast.classList.add("hidden"), duration);
}

// ======================================
// Product Catalog (Gallery)
// ======================================
const exampleProducts = [
  // Group Classes
  {
    id: "group-yoga",
    name: "Group Yoga Class",
    description: "Join our community group yoga class",
    price: 25.00,
    img: "images/Client2_GroupYoga.png",
    category: "yoga"
  },
  {
    id: "group-kickboxing",
    name: "Group Kickboxing Class",
    description: "High-energy group kickboxing class",
    price: 30.00,
    img: "images/Client2_GroupKickboxing.png",
    category: "kickboxing"
  },
  {
    id: "group-pilates",
    name: "Group Pilates Class",
    description: "Join our community group Pilates class",
    price: 28.00,
    img: "images/Client2_GroupPilates.png",
    category: "pilates"
  },
  
  // Individual Classes
  {
    id: "individual-yoga",
    name: "Individual Yoga Session",
    description: "One-on-one personalized yoga instruction",
    price: 60.00,
    img: "images/Client2_IndividualYoga.png",
    category: "yoga"
  },
  {
    id: "individual-kickboxing",
    name: "Individual Kickboxing Session",
    description: "One-on-one personalized kickboxing training",
    price: 65.00,
    img: "images/Client2_IndividualKickboxing.png",
    category: "kickboxing"
  },
  {
    id: "individual-pilates",
    name: "Individual Pilates Session",
    description: "One-on-one personalized Pilates training",
    price: 62.00,
    img: "images/Client2_IndividualPilates.png",
    category: "pilates"
  },
  
  // Equipment & Merchandise
  {
    id: "yoga-mat",
    name: "Premium Yoga Mat",
    description: "Non-slip, eco-friendly yoga mat with extra cushioning",
    price: 49.99,
    img: "images/Client2_YogaMat.png",
    category: "equipment"

  },
  {
    id: "tshirt",
    name: "ABC Fitness T-Shirt",
    description: "Premium quality branded fitness t-shirt",
    price: 24.99,
    img: "images/Client2_TeeShirt.png",
    category: "merchandise"
  },
  {
    id: "water-bottle",
    name: "Insulated Water Bottle",
    description: "Insulated stainless steel water bottle, 32oz",
    price: 19.99,
    img: "images/Client2_WaterBottle.png",
    category: "equipment"
  },
];

const featuredProducts = [
  {
    id: "yoga-mat",
    name: "Premium Yoga Mat",
    description: "High-quality, non-slip mat for all levels",
    price: 49.99,
    img: "images/Client2_YogaMat.png",
  },
  {
    id: "tee-shirt",
    name: "ABC Fitness T-Shirt",
    description: "Comfortable and breathable workout tee",
    price: 24.99,
    img: "images/Client2_TeeShirt.png",
  }
];

function loadProducts() {
  const grid = document.getElementById("products-grid");
  if (!grid) return;
  
  grid.innerHTML = exampleProducts
    .map(
      (p) => `
      <div class="product-card">
        <div class="product-image-wrapper">
          <img src="${p.img}" alt="${p.name}" class="product-image">
        </div>
        <div class="product-info">
          <h3 class="product-name">${p.name}</h3>
          <p class="product-description">${p.description}</p>
          <p class="product-price">$${p.price.toFixed(2)}</p>
          <button class="btn-primary add-to-cart-btn" data-id="${p.id}">Add to Cart</button>
        </div>
      </div>`
    )
    .join("");

  // Attach click listeners
  document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const product = exampleProducts.find(p => p.id === btn.dataset.id);
      if (product) addToCart(product);
    });
  });
}

// ======================================
// Render promo / featured products
// ======================================
function loadFeaturedProducts() {
  const container = document.querySelector('.featured-products');
  if (!container) return;

  container.innerHTML = featuredProducts
    .map(
      (p) => `
      <div class="product-promo clickable nav-btn" data-page="gallery">
        <div class="product-image-wrapper">
          <img src="${p.img}" alt="${p.name}" class="product-image">
        </div>
        <div class="product-info">
          <h3 class="product-name">${p.name}</h3>
          <p class="product-description">${p.description}</p>
          <p class="product-price">$${p.price}</p>
        </div>
      </div>`
    )
    .join('');
}

// ======================================
// Feedback Form Submission
// ======================================
const feedbackForm = document.getElementById('feedback-form');

if (feedbackForm) {
  feedbackForm.addEventListener('submit', function (e) {
    e.preventDefault(); // Prevent normal form submission

    // Collect form data
    const formData = {
      name: this.name.value.trim(),
      email: this.email.value.trim(),
      phone: this.phone.value.trim(),
      type: this.type.value,
      message: this.message.value.trim(),
      submittedAt: new Date().toISOString()
    };

    // Save to localStorage
    let feedback = [];
    try {
      const saved = localStorage.getItem('feedback');
      if (saved) feedback = JSON.parse(saved);
    } catch (err) {
      console.warn('Could not load feedback from storage:', err);
    }
    feedback.push(formData);
    localStorage.setItem('feedback', JSON.stringify(feedback));

    // Clear the form
    this.reset();

    // Show success dialog
    showFormSuccessDialog();
  });
}

// ======================================
// Initialize Everything
// ======================================
document.addEventListener('DOMContentLoaded', async () => {
  await loadPartials(); 
  setupNavigation();
  loadProducts();           
  loadCart();           
  updateCartUI();
  initializePage();

  const featuredContainer = document.querySelector('.featured-products');
  if (featuredContainer) {
    loadFeaturedProducts();       
  } else {
    console.warn('Featured products container not found.');
  }
});
