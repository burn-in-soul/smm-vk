from smm_vk.clients.vk_client.vk_client import VkClientV1
from aiovk import TokenSession


class VkClientContainer:

    def __init__(self, session: TokenSession):
        self.client = VkClientV1(session)
