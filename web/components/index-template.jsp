<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    Base template for index pages
    Usage: Include this file and set the following variables:
    - sectionTitle: Title of the section
    - sectionIcon: FontAwesome icon class
    - sectionColor: Bootstrap color class (primary, success, warning, info, danger)
    - sectionDescription: Brief description
    - addButtonText: Text for add button
    - addButtonUrl: URL for add action
    - listButtonText: Text for list button
    - listButtonUrl: URL for list action
    - helpText: Help text at bottom
--%>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="${sectionIcon} text-${sectionColor} me-2"></i>
                        ${sectionTitle}
                    </h2>
                    <p class="text-muted mb-0">${sectionDescription}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Cards -->
    <div class="row g-4">
        <!-- Add Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 hover-card">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="icon-circle bg-success bg-opacity-10 mx-auto mb-3">
                            <i class="fas fa-plus-circle text-success fa-2x"></i>
                        </div>
                    </div>
                    <h4 class="card-title mb-3">${addButtonText}</h4>
                    <p class="card-text text-muted mb-4">
                        ${addDescription}
                    </p>
                    <a href="${addButtonUrl}" class="btn btn-success btn-lg px-4">
                        <i class="fas fa-plus me-2"></i>
                        ${addButtonText}
                    </a>
                </div>
            </div>
        </div>

        <!-- List Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 hover-card">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="icon-circle bg-${sectionColor} bg-opacity-10 mx-auto mb-3">
                            <i class="fas fa-list text-${sectionColor} fa-2x"></i>
                        </div>
                    </div>
                    <h4 class="card-title mb-3">${listButtonText}</h4>
                    <p class="card-text text-muted mb-4">
                        ${listDescription}
                    </p>
                    <a href="${listButtonUrl}" class="btn btn-${sectionColor} btn-lg px-4">
                        <i class="fas fa-eye me-2"></i>
                        ${listButtonText}
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Help Text -->
    <div class="row mt-5">
        <div class="col-12">
            <div class="card border-0 bg-light">
                <div class="card-body text-center py-3">
                    <small class="text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        ${helpText}
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.hover-card {
    transition: all 0.3s ease;
    cursor: pointer;
}

.hover-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
}

.icon-circle {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-lg {
    padding: 12px 30px;
    font-weight: 500;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.btn-lg:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.card {
    border-radius: 12px;
}

.bg-light {
    background-color: #f8f9fa !important;
}
</style>
