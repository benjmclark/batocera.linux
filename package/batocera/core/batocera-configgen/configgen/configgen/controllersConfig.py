#!/usr/bin/env python

import xml.etree.ElementTree as ET
import batoceraFiles

from utils.logger import get_logger
eslog = get_logger(__name__)

"""Default mapping of Batocera keys to SDL_GAMECONTROLLERCONFIG keys."""
_DEFAULT_SDL_MAPPING = {
    'b':      'a',  'a':        'b',
    'x':      'y',  'y':        'x',
    'l2':     'lefttrigger',  'r2':    'righttrigger',
    'l3':     'leftstick',  'r3':    'rightstick',
    'pageup': 'leftshoulder', 'pagedown': 'rightshoulder',
    'start':     'start',  'select':    'back',
    'up': 'dpup', 'down': 'dpdown', 'left': 'dpleft', 'right': 'dpright',
    'joystick1up': 'lefty', 'joystick1left': 'leftx',
    'joystick2up': 'righty', 'joystick2left': 'rightx', 'hotkey': 'guide'
}

class Input:
    def __init__(self, name, type, id, value, code):
        self.name = name
        self.type = type
        self.id = id
        self.value = value
        self.code = code


class Controller:
    def __init__(self, configName, type, guid, player, index="-1", realName="", inputs=None, dev=None, nbbuttons=None, nbhats=None, nbaxes=None):
        self.type = type
        self.configName = configName
        self.index = index
        self.realName = realName
        self.guid = guid
        self.player = player
        self.dev = dev
        self.nbbuttons = nbbuttons
        self.nbhats = nbhats
        self.nbaxes = nbaxes
        if inputs == None:
            self.inputs = dict()
        else:
            self.inputs = inputs

    def generateSDLGameDBLine(self):
        return _generateSdlGameControllerConfig(self)


# Load all controllers from the es_input.cfg
def loadAllControllersConfig():
    controllers = dict()
    tree = ET.parse(batoceraFiles.esInputs)
    root = tree.getroot()
    for controller in root.findall(".//inputConfig"):
        controllerInstance = Controller(controller.get("deviceName"), controller.get("type"),
                                        controller.get("deviceGUID"), None, None)
        uidname = controller.get("deviceGUID") + controller.get("deviceName")
        controllers[uidname] = controllerInstance
        for input in controller.findall("input"):
            inputInstance = Input(input.get("name"), input.get("type"), input.get("id"), input.get("value"), input.get("code"))
            controllerInstance.inputs[input.get("name")] = inputInstance
    return controllers


# Load all controllers from the es_input.cfg
def loadAllControllersByNameConfig():
    controllers = dict()
    tree = ET.parse(batoceraFiles.esInputs)
    root = tree.getroot()
    for controller in root.findall(".//inputConfig"):
        controllerInstance = Controller(controller.get("deviceName"), controller.get("type"),
                                        controller.get("deviceGUID"), None, None)
        deviceName = controller.get("deviceName")
        controllers[deviceName] = controllerInstance
        for input in controller.findall("input"):
            inputInstance = Input(input.get("name"), input.get("type"), input.get("id"), input.get("value"), input.get("code"))
            controllerInstance.inputs[input.get("name")] = inputInstance
    return controllers


# Create a controller array with the player id as a key
def loadControllerConfig(controllersInput):
    playerControllers = dict()
    controllers = loadAllControllersConfig()

    for i, ci in enumerate(controllersInput):
        newController = findBestControllerConfig(controllers, str(i+1), ci["guid"], ci["index"], ci["name"], ci["devicepath"], ci["nbbuttons"], ci["nbhats"], ci["nbaxes"])
        if newController:
            playerControllers[str(i+1)] = newController
    return playerControllers

def findBestControllerConfig(controllers, x, pxguid, pxindex, pxname, pxdev, pxnbbuttons, pxnbhats, pxnbaxes):
    # when there will have more joysticks, use hash tables
    for controllerGUID in controllers:
        controller = controllers[controllerGUID]
        if controller.guid == pxguid and controller.configName == pxname:
            return Controller(controller.configName, controller.type, pxguid, x, pxindex, pxname,
                              controller.inputs, pxdev, pxnbbuttons, pxnbhats, pxnbaxes)
    for controllerGUID in controllers:
        controller = controllers[controllerGUID]
        if controller.guid == pxguid:
            return Controller(controller.configName, controller.type, pxguid, x, pxindex, pxname,
                              controller.inputs, pxdev, pxnbbuttons, pxnbhats, pxnbaxes)
    for controllerGUID in controllers:
        controller = controllers[controllerGUID]
        if controller.configName == pxname:
            return Controller(controller.configName, controller.type, pxguid, x, pxindex, pxname,
                              controller.inputs, pxdev, pxnbbuttons, pxnbhats, pxnbaxes)
    return None


def _generateSdlGameControllerConfig(controller, sdlMapping=_DEFAULT_SDL_MAPPING):
    """Returns an SDL_GAMECONTROLLERCONFIG-formatted string for the given configuration."""
    config = []
    config.append(controller.guid)
    config.append(controller.realName)
    config.append("platform:Linux")

    def add_mapping(input):
        keyname = sdlMapping.get(input.name, None)
        if keyname is None:
            return
        sdlConf = _keyToSdlGameControllerConfig(
            keyname, input.name, input.type, input.id, input.value)
        if sdlConf is not None:
            config.append(sdlConf)

    # "hotkey" is often mapped to an existing button but such a duplicate mapping
    # confuses SDL apps. We add "hotkey" mapping only if its target isn't also mapped elsewhere.
    hotkey_input = None
    mapped_button_ids = set()
    for k in controller.inputs:
        input = controller.inputs[k]
        if input.name is None:
            continue
        if input.name == 'hotkey':
            hotkey_input = input
            continue
        if input.type == 'button':
            mapped_button_ids.add(input.id)
        add_mapping(input)

    if hotkey_input is not None and not hotkey_input.id in mapped_button_ids:
        add_mapping(hotkey_input)
    config.append('')
    return ','.join(config)


def _keyToSdlGameControllerConfig(keyname, name, type, id, value=None):
    """
    Converts a key mapping to the SDL_GAMECONTROLLER format.

    Arguments:
      keyname: (str) SDL_GAMECONTROLLERCONFIG input name.
      name: (str) `es_input.cfg` input name.
      type: (str) 'button', 'hat', or 'axis'
      id: (int) Numeric key id.
      value: (int) Hat value. Only used if type == 'hat' or type == 'axis' and 'joystick' in name.
    Returns:
      (str) SDL_GAMECONTROLLERCONFIG-formatted key mapping string.
    Examples:
      _keyToSdlGameControllerConfig('leftshoulder', 'l1', 'button', 6)
        'leftshoulder:b6'

      _keyToSdlGameControllerConfig('dpleft', 'left', 'hat', 0, 8)
        'dpleft:h0.8'

      _keyToSdlGameControllerConfig('lefty', 'joystick1up', 'axis', 1, -1)
        'lefty:a1'

      _keyToSdlGameControllerConfig('lefty', 'joystick1up', 'axis', 1, 1)
        'lefty:a1~'

      _keyToSdlGameControllerConfig('dpup', 'up', 'axis', 1, -1)
        'dpup:-a1'
    """
    if type == 'button':
        return f'{keyname}:b{id}'
    elif type == 'hat':
        return f'{keyname}:h{id}.{value}'
    elif type == 'axis':
        if 'joystick' in name:
            return '{}:a{}{}'.format(keyname, id, '~' if int(value) > 0 else '')
        elif keyname in ('dpup', 'dpdown', 'dpleft', 'dpright'):
            return '{}:{}a{}'.format(keyname, '-' if int(value) < 0 else '+', id)
        else:
            return f'{keyname}:a{id}'
    elif type == 'key':
        return None
    else:
        raise ValueError('unknown key type: {!r}'.format(type))


def generateSdlGameControllerConfig(controllers):
    configs = []
    for idx, controller in controllers.items():
        configs.append(controller.generateSDLGameDBLine())
    return "\n".join(configs)


def writeSDLGameDBAllControllers(controllers, outputFile = "/tmp/gamecontrollerdb.txt"):
    with open(outputFile, "w") as text_file:
        text_file.write(generateSdlGameControllerConfig(controllers))
    return outputFile

def generateSdlGameControllerPadsOrderConfig(controllers):
    res = ""
    for idx, controller in controllers.items():
        if res != "":
            res = res + ";"
        res = res + str(controller.index)
    return res

def gunsNeedCrosses(guns):
    for gun in guns:
        if guns[gun]["need_cross"]:
            return True
    return False

def getGuns():
    import pyudev
    import re

    guns = {}
    context = pyudev.Context()

    # guns are mouses, just filter on them
    mouses = context.list_devices(subsystem='input')

    # keep only mouses with /dev/iput/eventxx
    mouses_clean = {}
    for mouse in mouses:
        matches = re.match(r"^/dev/input/event([0-9]*)$", str(mouse.device_node))
        if matches != None:
            if ("ID_INPUT_MOUSE" in mouse.properties and mouse.properties["ID_INPUT_MOUSE"]) == '1':
                mouses_clean[int(matches.group(1))] = mouse
    mouses = mouses_clean

    nmouse = 0
    ngun   = 0
    for eventid in sorted(mouses):
        eslog.info("found mouse {} at {} with id_mouse={}".format(nmouse, mouses[eventid].device_node, nmouse))
        if "ID_INPUT_GUN" not in mouses[eventid].properties or mouses[eventid].properties["ID_INPUT_GUN"] != "1":
            nmouse = nmouse + 1
            continue
        # retroarch uses mouse indexes into configuration files using ID_INPUT_MOUSE (TOUCHPAD are listed after mouses)
        need_cross = "ID_INPUT_GUN_NEED_CROSS" in mouses[eventid].properties and mouses[eventid].properties["ID_INPUT_GUN_NEED_CROSS"] == '1'
        guns[ngun] = {"node": mouses[eventid].device_node, "id_mouse": nmouse, "need_cross": need_cross}
        eslog.info("found gun {} at {} with id_mouse={}".format(ngun, mouses[eventid].device_node, nmouse))
        nmouse = nmouse + 1
        ngun = ngun + 1

    if len(guns) == 0:
        eslog.info("no gun found")
    return guns
