from django.db import models
from cloudinary.models import CloudinaryField

# Create your models here.
class Project(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    image = CloudinaryField(
        'image',
        folder='patsul/projects',
        blank=True,
        null=True
    )
    github_url = models.URLField(max_length=500, blank=True, default='')
    live_url = models.URLField(max_length=500, blank=True, default='')
    display_order = models.IntegerField(default=0)
    is_featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['display_order', '-created_at']

    def __str__(self):
        return self.title

    @property
    def image_url(self):
        """Return the Cloudinary URL or empty string"""
        if self.image:
            return self.image.url
        return ''
