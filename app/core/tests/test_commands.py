from unittest.mock import MagicMock, patch

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase
from psycopg2 import OperationalError as Pyscopg2Error


@patch("core.management.commands.wait_for_db.Command.check")
class CommandTest(SimpleTestCase):
    def test_for_db_ready(self, mock_check: MagicMock) -> None:
        """
        Case when the database is ready
        """
        mock_check.return_value = True
        call_command("wait_for_db")
        mock_check.assert_called_once_with(databases=["default"])

    @patch("core.management.commands.wait_for_db.sleep")
    def test_for_db_delay(self, _: MagicMock, mock_check: MagicMock) -> None:
        """
        Case we wait for the database to be ready after it returning multiple errors
        """
        mock_check.side_effect = [Pyscopg2Error] * 2 + [OperationalError] * 3 + [True]
        call_command("wait_for_db")
        self.assertEqual(mock_check.call_count, 6)
        mock_check.assert_called_with(databases=["default"])
