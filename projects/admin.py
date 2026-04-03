from django.contrib import admin
from .models import Project

# Register your models here.
@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ['title', 'display_order', 'is_featured', 'created_at']
    list_editable = ['display_order', 'is_featured']
    search_fields = ['title', 'description']