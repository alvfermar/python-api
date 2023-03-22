from time import sleep

from django.core.management.base import BaseCommand
from django.db.utils import OperationalError
from psycopg2 import OperationalError as Pyscopg2Error


class Command(BaseCommand):
    """Command to wait for the database to be ready"""

    def handle(self, *args, **options) -> None:  # type: ignore[no-untyped-def]
        """Entrypoint for the command"""
        self.stdout.write("Waiting for the database to be ready...")
        db_up: bool = False

        while not db_up:
            try:
                self.check(databases=["default"])
                db_up = True

            except (Pyscopg2Error, OperationalError):
                self.stdout.write('Database not ready, waiting 1"...')
                sleep(1)

        self.stdout.write(self.style.SUCCESS("Database available!"))
