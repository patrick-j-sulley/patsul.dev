"""
Custom management command: create_superuser

Creates a superuser with username "admin" if one does not already exist.
Safe to run multiple times (idempotent).

Password resolution order:
  1. DJANGO_SUPERUSER_PASSWORD environment variable
  2. Auto-generated 20-character random password (printed to stdout once)

Usage:
  python manage.py create_superuser
"""

import os
import secrets
import string

from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand

SUPERUSER_USERNAME = "admin"
SUPERUSER_EMAIL = "admin@patsul.dev"
PASSWORD_ENV_VAR = "DJANGO_SUPERUSER_PASSWORD"
GENERATED_PASSWORD_LENGTH = 20


class Command(BaseCommand):
    help = (
        "Creates a superuser with username 'admin' if one does not already "
        "exist. Password is read from the DJANGO_SUPERUSER_PASSWORD env var, "
        "or auto-generated when the variable is not set."
    )

    def handle(self, *args, **options):
        User = get_user_model()

        if User.objects.filter(username=SUPERUSER_USERNAME).exists():
            self.stdout.write(
                self.style.WARNING(
                    f"Superuser '{SUPERUSER_USERNAME}' already exists — skipping."
                )
            )
            return

        password = os.environ.get(PASSWORD_ENV_VAR)
        generated = False

        if not password:
            alphabet = string.ascii_letters + string.digits + string.punctuation
            password = "".join(secrets.choice(alphabet) for _ in range(GENERATED_PASSWORD_LENGTH))
            generated = True

        User.objects.create_superuser(
            username=SUPERUSER_USERNAME,
            email=SUPERUSER_EMAIL,
            password=password,
        )

        self.stdout.write(
            self.style.SUCCESS(
                f"Superuser '{SUPERUSER_USERNAME}' created successfully."
            )
        )

        if generated:
            self.stdout.write(
                self.style.WARNING(
                    f"No {PASSWORD_ENV_VAR} env var found. "
                    f"Auto-generated password: {password}\n"
                    "Set DJANGO_SUPERUSER_PASSWORD to use a fixed password on future deploys."
                )
            )
